#!/usr/bin/python3

import os
import subprocess
import sys
import numpy as np
import chromaprint
from pathlib import Path

MUSICDIR = Path.home() / "Workspace/temp"
CACHE    = MUSICDIR / "cache.txt"
LOG    = MUSICDIR / "log.txt"
STRONG_THRESHOLD = 0.10
WEAK_THRESHOLD = 0.35

# ---------- fingerprint helpers ----------

def tag_file(filepath):
    result = subprocess.run(['opustags', str(filepath)], capture_output=True, text=True)
    if not any(l.startswith('fingerprint=') for l in result.stdout.splitlines()):
        fpcalc = subprocess.run(['fpcalc', str(filepath)], capture_output=True, text=True)
        tag = next(
            (l.removeprefix('FINGERPRINT=') for l in fpcalc.stdout.splitlines()
             if l.startswith('FINGERPRINT=')), None
        )
        if tag:
            subprocess.run(['opustags', '-i', str(filepath), '--add', f'fingerprint={tag}'])
            print(f"tagging:  {filepath.name}")
        else:
            print(f"failed:   {filepath.name}", file=sys.stderr)
    else:
        print(f"skipping: {filepath.name}")

def read_fingerprint(filepath):
    result = subprocess.run(['opustags', str(filepath)], capture_output=True, text=True)
    line = next(
        (l for l in result.stdout.splitlines() if l.startswith('fingerprint=')), None
    )
    if line is None:
        return None
    return chromaprint.decode_fingerprint(
        line.removeprefix('fingerprint=').encode('ascii')
    )[0]

# ---------- comparison (unchanged from music-dupes.py) ----------

def compare_arrays(fp1, fp2, probe_seconds=30.0, verify_seconds=60.0):
    a1 = np.array(fp1, dtype=np.uint32)
    a2 = np.array(fp2, dtype=np.uint32)

    probe_len = min(int(probe_seconds * 2), len(a1), len(a2))
    verify_len = min(int(verify_seconds * 2), len(a1), len(a2))

    mid = len(a1) // 2
    probe_start = max(0, mid - probe_len // 2)
    probe = a1[probe_start:probe_start + probe_len]

    best_dist, best_j = 1.0, 0
    for j in range(len(a2) - probe_len + 1):
        xored = np.bitwise_xor(probe, a2[j:j + probe_len])
        dist = int(np.unpackbits(xored.view(np.uint8)).sum()) / (probe_len * 32)
        if dist < best_dist:
            best_dist, best_j = dist, j

    v1_start = max(0, probe_start - (verify_len - probe_len) // 2)
    v2_start = max(0, best_j    - (verify_len - probe_len) // 2)
    v1_end   = min(len(a1), v1_start + verify_len)
    v2_end   = min(len(a2), v2_start + verify_len)
    v_len    = min(v1_end - v1_start, v2_end - v2_start)

    verify_xored = np.bitwise_xor(a1[v1_start:v1_start+v_len], a2[v2_start:v2_start+v_len])
    verify_dist  = int(np.unpackbits(verify_xored.view(np.uint8)).sum()) / (v_len * 32)

    return verify_dist < WEAK_THRESHOLD, verify_dist

# ---------- keeper selection ----------

#    def pick_keeper(a, b):
#        return (a, b) if a.stat().st_size >= b.stat().st_size else (b, a)

#   # ---------- dupe review ----------

#   def review_dupes():
#       if not DUPES.exists() or DUPES.stat().st_size == 0:
#           print("No duplicates recorded.")
#           return
#       lines = DUPES.read_text().splitlines()
#       pairs = [(label,Path(a),Path(b)) for label,a,b in l.split('|') for l in lines if l.count('|') == 2]
#       print(f"\n=== {len(pairs)} duplicate pair(s) to review ===\n")
#       remaining = []
#       for raw_a, raw_b in pairs:
#           a, b = Path(raw_a), Path(raw_b)
#           if not a.exists() or not b.exists():
#               print(f"  Skipping (already gone): {a.name} / {b.name}\n")
#               continue
#           keeper, to_delete = pick_keeper(a, b)
#           print(f" [{label}] Keep:   {keeper.name} ({keeper.stat().st_size:,} bytes)")
#           print(f" [{label}] Delete: {to_delete.name} ({to_delete.stat().st_size:,} bytes)")
#           choice = input("  Delete? [y/N/q] ").strip().lower()
#           if choice == 'q':
#               remaining.extend(f"{ra}|{rb}" for ra, rb in [(raw_a, raw_b)] + 
#                                [(str(pa), str(pb)) for pa, pb in 
#                                 [(Path(x.split('|')[0]), Path(x.split('|')[1])) 
#                                  for x in lines[lines.index(f"{raw_a}|{raw_b}")+1:]]])
#               break
#           if choice == 'y':
#               to_delete.unlink()
#               print(f"  Deleted.")
#           else:
#               print(f"  Skipped.")
#               remaining.append(f"{raw_a}|{raw_b}")
#           print()
#       DUPES.write_text('\n'.join(remaining) + ('\n' if remaining else ''))

# ---------- main ----------

def main():
    files = sorted(f for f in MUSICDIR.iterdir() if f.is_file())

    # Phase 1: tag anything untagged
    for f in files:
        tag_file(f)

    fps = {}
    for f in files:
        fps[f] = read_fingerprint(f)

    # Phase 2: build cache if this is a fresh run
    if not CACHE.exists():
        CACHE.write_text('\n'.join(str(f) for f in files) + '\n')
        print(f"Cache written: {len(files)} files\n")
    else:
        remaining = CACHE.read_text().splitlines()
        print(f"Resuming: {len(remaining)} files left in outer loop\n")

    with LOG.open('a') as fh:
        fh.write("### STARTING ###\n")

    # Phase 3: work through the cache
    while CACHE.exists() and CACHE.stat().st_size > 0:
        lines    = CACHE.read_text().splitlines()
        song1    = Path(lines[0])

        # The remaining list IS the inner loop — same as your bash version
        remaining = [Path(l) for l in lines[1:]]

        #print(f"Comparing {song1.name} against {len(remaining)} files...")
        #fp1 = read_fingerprint(song1)
        fp1 = fps.get(song1)
        if fp1 is not None:
            for song2 in remaining:
                fp2 = fps.get(song2)
                if fp2 is not None:
                    is_match, dist = compare_arrays(fp1, fp2)
                    if is_match:
                        label = "STRONG" if dist < STRONG_THRESHOLD else "WEAK  "
                        print(f" {label} ({dist:.3f}): {song1.name}  <=>  {song2.name}")
                        with LOG.open('a') as fh:
                            fh.write(f"{label}|{song1}|{song2}\n")

        # Pop song1 from cache — this is the atomic progress commit
        CACHE.write_text('\n'.join(str(p) for p in remaining) + ('\n' if remaining else ''))
        #print(f"  Done. {len(remaining)} files remaining.\n")

    CACHE.unlink(missing_ok=True)
    print("Scan complete.\n")

    # Phase 4: interactive dupe review
#    review_dupes()

if __name__ == '__main__':
    main()
