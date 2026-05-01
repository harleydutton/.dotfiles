#!/usr/bin/env python3
"""
opus_dupes.py — Fingerprint and cluster .opus files to find duplicates.

Uses Chromaprint acoustic fingerprints with MinHash LSH to find candidate
pairs in sub-quadratic time, then verifies with exact bit-error-rate comparison.

Usage:
    python3 opus_dupes.py /path/to/music [options]

Options:
    --threshold FLOAT   Fingerprint similarity threshold 0.0-1.0 (default: 0.90)
    --bands     INT     LSH bands (default: 20). More bands = higher recall,
                        more candidate pairs to verify. Fewer = faster but may
                        miss near-threshold matches.
    --rows      INT     LSH rows per band (default: 4). bands x rows = total hash
                        functions. Increasing rows raises the similarity threshold
                        at which LSH fires.
    --cache FILE        Path to fingerprint cache JSON (default: .opus_fp_cache.json
                        in the music directory)
    --report FILE       Write a plain-text report to FILE instead of stdout
    --no-color          Disable ANSI color output
    --delete            Interactively prompt to delete duplicates (DRY RUN unless
                        combined with --confirm)
    --confirm           Actually delete when used with --delete (no dry run)

Dependencies:
    dnf install mutagen
    dnf install libchromaprint-tools   # provides fpcalc

LSH overview
------------
Chromaprint fingerprints are arrays of 32-bit integers (after base64 decoding).
Each integer is a frame of spectral similarity hashes. We treat the array as a
multiset and build a MinHash signature over it. Two files with similar audio will
share many of the same integers and therefore have similar MinHash signatures.

LSH splits the signature into `bands` of `rows` values each. Two files that are
identical in ALL rows of ANY band collide into the same bucket and become a
candidate pair. The probability of a collision for a pair with true Jaccard
similarity J is:

    P(candidate) = 1 - (1 - J^rows)^bands

With bands=20, rows=4 (defaults): P~0.99 at J=0.80, negligible false-negative
rate for near-duplicate audio (J>=0.85).

Candidate pairs are then verified with exact BER similarity and clustered via
union-find.
"""

import argparse
import json
import os
import struct
import subprocess
import sys
import time
from collections import defaultdict
from pathlib import Path

# ── Color helpers ─────────────────────────────────────────────────────────────

try:
    import shutil as _shutil
    _COLS = _shutil.get_terminal_size((80, 20)).columns
except Exception:
    _COLS = 80

RESET  = "\033[0m"
BOLD   = "\033[1m"
RED    = "\033[91m"
YELLOW = "\033[93m"
GREEN  = "\033[92m"
CYAN   = "\033[96m"
DIM    = "\033[2m"


def strip_color(s: str) -> str:
    import re
    return re.sub(r"\033\[[0-9;]*m", "", s)


def c(text, *codes, use_color=True):
    if not use_color:
        return str(text)
    return "".join(codes) + str(text) + RESET


# ── Fingerprinting ────────────────────────────────────────────────────────────

def get_fingerprint(path: Path) -> dict | None:
    """Run fpcalc on a file. Returns {'duration': float, 'fingerprint': str} or None."""
    try:
        result = subprocess.run(
            ["fpcalc", "-json", str(path)],
            capture_output=True, text=True, timeout=30
        )
        if result.returncode != 0:
            return None
        data = json.loads(result.stdout)
        return {"duration": float(data["duration"]), "fingerprint": data["fingerprint"]}
    except Exception:
        return None


def fp_to_ints(fingerprint: str) -> list[int]:
    """
    Decode a Chromaprint base64url fingerprint into a list of unsigned 32-bit ints.
    Chromaprint encodes raw bytes as base64url (RFC 4648 s5) without padding,
    little-endian int32 layout.
    """
    import base64
    fp = fingerprint.replace("-", "+").replace("_", "/")
    pad = (4 - len(fp) % 4) % 4
    raw = base64.b64decode(fp + "=" * pad)
    count = len(raw) // 4
    return list(struct.unpack(f"<{count}I", raw[:count * 4]))


def fingerprint_similarity(ints_a: list[int], ints_b: list[int]) -> float:
    """
    Bit-error-rate similarity over the overlapping prefix of two fingerprints.
    Returns 0.0 (totally different) to 1.0 (identical).
    """
    length = min(len(ints_a), len(ints_b))
    if length == 0:
        return 0.0
    matching = sum(32 - bin(x ^ y).count("1") for x, y in zip(ints_a, ints_b))
    return matching / (length * 32)


# ── Metadata ──────────────────────────────────────────────────────────────────

def get_metadata(path: Path) -> dict:
    """Extract Vorbis Comment tags from an Ogg Opus file via mutagen."""
    try:
        from mutagen.oggopus import OggOpus
        audio = OggOpus(str(path))
        tags = {}
        for key in ("title", "artist", "album", "date", "purl", "comment", "url"):
            val = audio.get(key)
            if val:
                tags[key] = val[0] if len(val) == 1 else list(val)
        return tags
    except Exception:
        return {}


# ── Caching ───────────────────────────────────────────────────────────────────

def load_cache(cache_path: Path) -> dict:
    if cache_path.exists():
        try:
            with open(cache_path) as f:
                return json.load(f)
        except Exception:
            pass
    return {}


def save_cache(cache_path: Path, cache: dict):
    with open(cache_path, "w") as f:
        json.dump(cache, f, indent=2)


# ── MinHash ───────────────────────────────────────────────────────────────────

_MERSENNE_PRIME = (1 << 61) - 1  # M61 — large prime for universal hashing


def _make_hash_params(n: int, seed: int = 0xDEADBEEF) -> list[tuple[int, int]]:
    """
    Generate n (a, b) coefficient pairs for universal hashing h(x) = (a*x + b) mod p.
    Seeded for determinism across runs.
    """
    import random
    rng = random.Random(seed)
    return [
        (rng.randint(1, _MERSENNE_PRIME - 1), rng.randint(0, _MERSENNE_PRIME - 1))
        for _ in range(n)
    ]


def compute_minhash(ints: list[int], hash_params: list[tuple[int, int]]) -> list[int]:
    """
    Compute a MinHash signature of length len(hash_params).
    Each slot is the minimum hash value across all elements under one hash function.
    We hash each 32-bit int directly (not subsets), treating the fingerprint array
    as a set/multiset of spectral frame hashes.
    """
    sig = [_MERSENNE_PRIME] * len(hash_params)
    for x in ints:
        for i, (a, b) in enumerate(hash_params):
            h = (a * x + b) % _MERSENNE_PRIME
            if h < sig[i]:
                sig[i] = h
    return sig


# ── LSH ───────────────────────────────────────────────────────────────────────

def build_lsh_index(
    entries: list[dict],
    bands: int,
    rows: int,
    hash_params: list[tuple[int, int]],
    progress: bool = True,
    use_color: bool = True,
) -> dict[bytes, list[int]]:
    """
    Compute MinHash signatures and populate LSH band buckets.

    For each entry, the signature is split into `bands` bands of `rows` values.
    Each band is hashed to a bucket key. Any two files sharing a bucket for any
    band become a candidate pair.

    Returns: dict mapping bucket_bytes -> list of entry indices.
    """
    buckets: dict[bytes, list[int]] = defaultdict(list)
    n = len(entries)

    for i, entry in enumerate(entries):
        ints = entry.get("_ints", [])
        if not ints:
            continue

        sig = compute_minhash(ints, hash_params)

        for band_idx in range(bands):
            band_vals = sig[band_idx * rows : (band_idx + 1) * rows]
            # Key = band index (8 bytes) + each signature value (8 bytes each)
            key = struct.pack(f"<{1 + rows}Q", band_idx,
                              *[v % (2**64) for v in band_vals])
            buckets[key].append(i)

        if progress:
            pct    = (i + 1) / n * 100
            bar_w  = 28
            filled = int(bar_w * (i + 1) / n)
            bar    = "█" * filled + "░" * (bar_w - filled)
            print(
                f"\r  {c(bar, CYAN, use_color=use_color)} {pct:5.1f}%  "
                f"{c('building index', DIM, use_color=use_color)}",
                end="", flush=True,
            )

    if progress:
        print()

    return buckets


def candidate_pairs_from_lsh(buckets: dict[bytes, list[int]]) -> set[tuple[int, int]]:
    """Return all (i, j) pairs that share at least one LSH bucket, with i < j."""
    candidates: set[tuple[int, int]] = set()
    for indices in buckets.values():
        if len(indices) < 2:
            continue
        for a in range(len(indices)):
            for b in range(a + 1, len(indices)):
                i, j = indices[a], indices[b]
                candidates.add((min(i, j), max(i, j)))
    return candidates


# ── Union-Find ────────────────────────────────────────────────────────────────

class UnionFind:
    def __init__(self, n: int):
        self.parent = list(range(n))
        self.rank   = [0] * n

    def find(self, x: int) -> int:
        while self.parent[x] != x:
            self.parent[x] = self.parent[self.parent[x]]  # path compression
            x = self.parent[x]
        return x

    def union(self, x: int, y: int):
        rx, ry = self.find(x), self.find(y)
        if rx == ry:
            return
        if self.rank[rx] < self.rank[ry]:
            rx, ry = ry, rx
        self.parent[ry] = rx
        if self.rank[rx] == self.rank[ry]:
            self.rank[rx] += 1

    def clusters(self, entries: list) -> list[list]:
        buckets: dict[int, list] = defaultdict(list)
        for i, entry in enumerate(entries):
            buckets[self.find(i)].append(entry)
        return [v for v in buckets.values() if len(v) > 1]


# ── Full pipeline ─────────────────────────────────────────────────────────────

def cluster_files(
    files_meta: list[dict],
    threshold: float,
    bands: int,
    rows: int,
    progress: bool = True,
    use_color: bool = True,
) -> list[list[dict]]:
    """
    LSH + exact-verification clustering pipeline:

    1. Decode fingerprint strings to int arrays (_ints, transient).
    2. Build MinHash signatures and populate LSH band buckets.
    3. Extract candidate pairs from shared buckets.
    4. Verify each candidate with duration gate + exact BER similarity.
    5. Union-find clustering over verified pairs.
    """
    total_hashes = bands * rows

    # Step 1 — decode
    for entry in files_meta:
        fp = entry.get("fingerprint")
        entry["_ints"] = fp_to_ints(fp) if fp else []

    eligible  = [e for e in files_meta if e["_ints"]]
    n_elig    = len(eligible)
    max_pairs = n_elig * (n_elig - 1) // 2

    print(c(f"  {n_elig} files with fingerprints", DIM, use_color=use_color))
    print(c(
        f"  LSH config: {bands} bands x {rows} rows = {total_hashes} hash functions",
        DIM, use_color=use_color,
    ))
    print(c(
        f"  Brute-force would check {max_pairs:,} pairs — "
        f"LSH will reduce this significantly",
        DIM, use_color=use_color,
    ))
    print()

    # Step 2 — build index
    hash_params = _make_hash_params(total_hashes)
    buckets = build_lsh_index(
        eligible, bands, rows, hash_params, progress=progress, use_color=use_color
    )

    # Step 3 — extract candidates
    candidates = candidate_pairs_from_lsh(buckets)
    if max_pairs > 0:
        reduction = 1.0 - len(candidates) / max_pairs
        print(c(
            f"\n  Candidate pairs: {len(candidates):,}  "
            f"({reduction:.1%} reduction from brute force)",
            GREEN, use_color=use_color,
        ))
    else:
        print(c(f"\n  Candidate pairs: {len(candidates):,}", GREEN, use_color=use_color))
    print()

    # Step 4 — verify
    uf = UnionFind(n_elig)
    n_cands = len(candidates)

    for idx, (i, j) in enumerate(candidates):
        ei, ej = eligible[i], eligible[j]

        # Duration gate: skip pairs differing by more than 5 seconds
        if abs(ei.get("duration", 0) - ej.get("duration", 0)) > 5:
            continue

        sim = fingerprint_similarity(ei["_ints"], ej["_ints"])
        if sim >= threshold:
            uf.union(i, j)

        if progress and n_cands > 0 and (idx + 1) % max(1, n_cands // 100) == 0:
            pct    = (idx + 1) / n_cands * 100
            bar_w  = 28
            filled = int(bar_w * (idx + 1) / n_cands)
            bar    = "█" * filled + "░" * (bar_w - filled)
            print(
                f"\r  {c(bar, YELLOW, use_color=use_color)} {pct:5.1f}%  "
                f"{c('verifying', DIM, use_color=use_color)}",
                end="", flush=True,
            )

    if progress and n_cands > 0:
        print()

    # Cleanup transient data
    for entry in files_meta:
        entry.pop("_ints", None)

    return uf.clusters(eligible)


# ── Reporting ─────────────────────────────────────────────────────────────────

def fmt_duration(seconds: float) -> str:
    m, s = divmod(int(seconds), 60)
    h, m = divmod(m, 60)
    return f"{h}:{m:02d}:{s:02d}" if h else f"{m}:{s:02d}"


def fmt_size(path: Path) -> str:
    try:
        b = path.stat().st_size
        for unit in ("B", "KB", "MB", "GB"):
            if b < 1024:
                return f"{b:.1f} {unit}"
            b /= 1024
        return f"{b:.1f} TB"
    except Exception:
        return "?"


def print_report(
    clusters: list[list[dict]],
    errors: list[tuple[str, str]],
    total: int,
    use_color: bool = True,
    file=sys.stdout,
):
    def out(s=""):
        print(strip_color(s) if not use_color else s, file=file)

    rule = "─" * min(_COLS, 72)
    out(c(f"\n{'═' * min(_COLS, 72)}", BOLD, use_color=use_color))
    out(c("  OPUS DUPLICATE REPORT", BOLD, CYAN, use_color=use_color))
    out(c(f"{'═' * min(_COLS, 72)}", BOLD, use_color=use_color))
    dupe_files = sum(len(g) for g in clusters)
    out(f"  Files scanned    : {total}")
    out(f"  Duplicate groups : {len(clusters)}  ({dupe_files} files involved)")
    out(f"  Errors           : {len(errors)}")
    out()

    if not clusters:
        out(c("  No duplicates found.", DIM, use_color=use_color))
        out()
    else:
        out(c("  DUPLICATE CLUSTERS", BOLD, YELLOW, use_color=use_color))
        out(c(f"  {rule}", DIM, use_color=use_color))
        for i, group in enumerate(clusters, 1):
            out(c(f"\n  Cluster {i}  ({len(group)} files)", BOLD, use_color=use_color))
            for entry in group:
                path   = Path(entry["path"])
                dur    = fmt_duration(entry.get("duration", 0))
                size   = fmt_size(path)
                meta   = entry.get("meta", {})
                title  = meta.get("title", "")
                artist = meta.get("artist", "")
                if artist and title:
                    tag_line = f" — {artist} · {title}"
                elif artist or title:
                    tag_line = f" — {artist or title}"
                else:
                    tag_line = ""
                out(f"    {c('>', YELLOW, use_color=use_color)} {path.name}")
                out(
                    f"      {c(dur, DIM, use_color=use_color)}  "
                    f"{c(size, DIM, use_color=use_color)}"
                    f"{c(tag_line, CYAN, use_color=use_color)}"
                )
        out()

    if errors:
        out(c("  ERRORS", BOLD, RED, use_color=use_color))
        for path_str, reason in errors:
            out(f"    {c('x', RED, use_color=use_color)} {Path(path_str).name}: {reason}")
        out()

    out(c(f"{'═' * min(_COLS, 72)}\n", BOLD, use_color=use_color))


# ── Interactive deletion ───────────────────────────────────────────────────────

def interactive_delete(
    clusters: list[list[dict]], dry_run: bool = True, use_color: bool = True
):
    mode = "DRY RUN" if dry_run else "LIVE"
    print(c(f"\n  INTERACTIVE DELETION MODE ({mode})", BOLD, RED, use_color=use_color))
    if dry_run:
        print(c(
            "  Files will NOT be deleted. Re-run with --confirm to actually delete.\n",
            DIM, use_color=use_color,
        ))

    for i, group in enumerate(clusters, 1):
        print(c(f"\nCluster {i}/{len(clusters)}", BOLD, use_color=use_color))
        for idx, entry in enumerate(group):
            path = Path(entry["path"])
            print(
                f"  [{idx}] {path.name}  "
                f"({fmt_duration(entry.get('duration', 0))}, {fmt_size(path)})"
            )
        print("  [s] skip this cluster")
        choice = input("  Delete which indices? (space-separated, or 's'): ").strip().lower()

        if not choice or choice == "s":
            print("  Skipped.")
            continue

        to_delete = []
        for token in choice.split():
            try:
                idx = int(token)
                if 0 <= idx < len(group):
                    to_delete.append(group[idx]["path"])
                else:
                    print(c(f"  Index {idx} out of range, skipped.", YELLOW, use_color=use_color))
            except ValueError:
                print(c(f"  Invalid input: {token!r}", YELLOW, use_color=use_color))

        for path_str in to_delete:
            name = Path(path_str).name
            if dry_run:
                print(f"  {c('DRY RUN', YELLOW, use_color=use_color)} would delete: {name}")
            else:
                try:
                    os.remove(path_str)
                    print(f"  {c('Deleted', RED, use_color=use_color)}: {name}")
                except Exception as e:
                    print(c(f"  Error deleting {name}: {e}", RED, use_color=use_color))


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="Fingerprint and cluster .opus files to find duplicates (LSH-accelerated).",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("directory", help="Path to music directory")
    parser.add_argument(
        "--threshold", type=float, default=0.90,
        help="BER similarity threshold 0.0-1.0 (default: 0.90)",
    )
    parser.add_argument(
        "--bands", type=int, default=20,
        help="LSH bands (default: 20; more = higher recall)",
    )
    parser.add_argument(
        "--rows", type=int, default=4,
        help="LSH rows per band (default: 4; bands x rows = total hash funcs)",
    )
    parser.add_argument(
        "--cache", default=None,
        help="Fingerprint cache JSON path (default: <dir>/.opus_fp_cache.json)",
    )
    parser.add_argument("--report", default=None,
                        help="Write report to file instead of stdout")
    parser.add_argument("--no-color", action="store_true",
                        help="Disable ANSI color output")
    parser.add_argument("--delete", action="store_true",
                        help="Interactively prompt to delete duplicates (dry run by default)")
    parser.add_argument("--confirm", action="store_true",
                        help="Actually delete files when used with --delete")
    args = parser.parse_args()

    if args.bands < 1 or args.rows < 1:
        parser.error("--bands and --rows must be >= 1")
    if not 0.0 < args.threshold <= 1.0:
        parser.error("--threshold must be in (0.0, 1.0]")

    use_color = not args.no_color and sys.stdout.isatty()
    music_dir = Path(args.directory).expanduser().resolve()

    if not music_dir.is_dir():
        print(f"Error: {music_dir} is not a directory.", file=sys.stderr)
        sys.exit(1)

    opus_files = sorted(music_dir.glob("*.opus"))
    if not opus_files:
        print("No .opus files found.")
        sys.exit(0)

    cache_path = Path(args.cache) if args.cache else music_dir / ".opus_fp_cache.json"
    cache      = load_cache(cache_path)

    print(c(f"\n  Scanning {len(opus_files)} .opus files in {music_dir}", BOLD, use_color=use_color))
    print(c(f"  Cache: {cache_path}", DIM, use_color=use_color))
    print()

    # ── Phase 1: Fingerprint all files ───────────────────────────────────────
    files_meta: list[dict]          = []
    errors:     list[tuple[str,str]] = []
    width = len(str(len(opus_files)))

    for i, path in enumerate(opus_files):
        key    = str(path)
        mtime  = path.stat().st_mtime
        cached = cache.get(key)

        if cached and cached.get("mtime") == mtime:
            entry = cached
        else:
            fp_data = get_fingerprint(path)
            meta    = get_metadata(path)

            if fp_data is None:
                errors.append((key, "fpcalc failed"))
                entry = {"path": key, "mtime": mtime, "meta": meta}
            else:
                entry = {
                    "path":        key,
                    "mtime":       mtime,
                    "duration":    fp_data["duration"],
                    "fingerprint": fp_data["fingerprint"],
                    "meta":        meta,
                }
            cache[key] = entry
            if i % 20 == 0:
                save_cache(cache_path, cache)

        files_meta.append(entry)
        label = Path(key).name[:42].ljust(42)
        pct   = (i + 1) / len(opus_files) * 100
        print(
            f"\r  [{i+1:{width}}/{len(opus_files)}]  "
            f"{c(label, DIM, use_color=use_color)}  {pct:5.1f}%",
            end="", flush=True,
        )

    print()
    save_cache(cache_path, cache)
    print(c("  Fingerprinting complete. Cache saved.\n", GREEN, use_color=use_color))

    # ── Phase 2: LSH + verification ──────────────────────────────────────────
    print(c("  Phase 2: LSH clustering", BOLD, use_color=use_color))
    print(c(
        f"  Threshold: {args.threshold:.0%}  |  "
        f"bands: {args.bands}  rows: {args.rows}\n",
        DIM, use_color=use_color,
    ))

    t0 = time.time()
    clusters = cluster_files(
        files_meta,
        threshold=args.threshold,
        bands=args.bands,
        rows=args.rows,
        progress=sys.stdout.isatty(),
        use_color=use_color,
    )
    elapsed = time.time() - t0

    print(c(
        f"\n  Done in {elapsed:.1f}s. Found {len(clusters)} duplicate group(s).\n",
        GREEN, use_color=use_color,
    ))

    # ── Report ────────────────────────────────────────────────────────────────
    if args.report:
        with open(args.report, "w") as f:
            print_report(clusters, errors, len(opus_files), use_color=False, file=f)
        print(c(f"  Report written to: {args.report}", GREEN, use_color=use_color))
    else:
        print_report(clusters, errors, len(opus_files), use_color=use_color)

    # ── Optional deletion ─────────────────────────────────────────────────────
    if args.delete:
        if not clusters:
            print("  No duplicates to delete.")
        else:
            interactive_delete(clusters, dry_run=not args.confirm, use_color=use_color)


if __name__ == "__main__":
    main()
