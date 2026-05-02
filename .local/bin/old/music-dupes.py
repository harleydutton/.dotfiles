#!/usr/bin/python3

import subprocess
import sys
import base64
import chromaprint
import numpy as np
import time

#   def fingerprint(file):
#     return chromaprint.decode_fingerprint(subprocess.run(
#       f"opustags '{file}' | grep '^fingerprint=' | sed 's/fingerprint=//'", 
#       shell=True,capture_output=True,text=True
#     ).stdout.strip().encode('ascii'))[0]

def fingerprint(file):
    opustags = subprocess.run(
        ['opustags', file],
        capture_output=True, text=True
    )
    line = next((l for l in opustags.stdout.splitlines() if l.startswith('fingerprint=')), None)
    return chromaprint.decode_fingerprint(line.removeprefix('fingerprint=').encode('ascii'))[0]

def compare(f1, f2,
                         probe_seconds: float = 30.0,
                         verify_seconds: float = 60.0) -> dict:
    start = time.perf_counter()
    """
    1. Extract a probe from the MIDDLE of fp1 (avoids intro/outro junk)
    2. Slide it across fp2 to find the best offset
    3. Verify with a larger window at that offset
    """
    a1 = np.array(fingerprint(f1), dtype=np.uint32)
    a2 = np.array(fingerprint(f2), dtype=np.uint32)

    probe_len = min(int(probe_seconds * 2), len(a1), len(a2))
    verify_len = min(int(verify_seconds * 2), len(a1), len(a2))

    # Step 1: take probe from the middle of fp1
    mid = len(a1) // 2
    probe_start = max(0, mid - probe_len // 2)
    probe = a1[probe_start:probe_start + probe_len]

    # Step 2: slide probe across fp2
    best_dist = 1.0
    best_j = 0
    for j in range(len(a2) - probe_len + 1):
        xored = np.bitwise_xor(probe, a2[j:j + probe_len])
        bits = int(np.unpackbits(xored.view(np.uint8)).sum())
        dist = bits / (probe_len * 32)
        if dist < best_dist:
            best_dist = dist
            best_j = j

    # Step 3: verify with a larger window, aligning fp1 and fp2
    # Work out where in fp1 the match corresponds to
    fp2_match_start = best_j
    fp1_match_start = probe_start  # probe came from here

    # Expand to verify_len, staying in bounds
    v1_start = max(0, fp1_match_start - (verify_len - probe_len) // 2)
    v2_start = max(0, fp2_match_start - (verify_len - probe_len) // 2)
    v1_end = min(len(a1), v1_start + verify_len)
    v2_end = min(len(a2), v2_start + verify_len)
    v_len = min(v1_end - v1_start, v2_end - v2_start)

    verify_xored = np.bitwise_xor(a1[v1_start:v1_start+v_len], a2[v2_start:v2_start+v_len])
    verify_dist = int(np.unpackbits(verify_xored.view(np.uint8)).sum()) / (v_len * 32)

    return {
        "probe_distance": best_dist,
        "verify_distance": verify_dist,
        "is_match": verify_dist < 0.35,
        "fp1_match_offset_seconds": v1_start / 2.0,
        "fp2_match_offset_seconds": v2_start / 2.0,
        "elapsed_time": time.perf_counter() - start
    }

if len(sys.argv) > 2:
  print(compare(sys.argv[1],sys.argv[2]))
  
def td():
  path='/var/home/hdutton/Workspace/tags/'
  out = {}
  out['f1']=path+'AViVA - Blame It On The Kids [Z9lKN_X152Q].opus'
  out['f2']=path+'Blame It On The Sun [hQuRNOOh45Y].opus'
  out['f3']=path+'Blame It on My Youth [TOd1BgDPB10].opus'
  out['f4']=path+'Blame It On The Kids [MCiDs3uoGk0].opus'
  return out

def maxintstr():
  sys.set_int_max_str_digits(10000)
