#!/usr/bin/env python3
"""Select keyframe timestamps from raw scene-change candidates.

Screen recordings transition subtly and unevenly: a busy stretch (e.g. a slide
deck) can fire dozens of scene changes while a content-rich intro barely trips
the detector. Feeding raw scene timestamps straight to the extractor therefore
over-samples the busy tail and starves the rest of the timeline.

This helper turns candidate timestamps into a well-distributed final set by:
  1. Guaranteeing timeline coverage: every time-bucket with no candidate gets
     its midpoint, so no region of the video is left unrepresented.
  2. Capping frames per bucket: a busy stretch can't dominate the budget.
  3. Enforcing a minimum gap between kept frames: drops rapid-fire duplicates.
  4. Offsetting each timestamp a beat past the transition: frames land on the
     settled screen instead of mid-crossfade (which is usually motion-blurred).
  5. Always including the first and last of the video.

Usage: select_frames.py <duration_seconds>   (candidate times on stdin, one
per line as floats). Prints the final timestamps (seconds, 2dp), one per line.
"""
import math
import sys

BUCKET_MIN = 20.0      # never bucket the timeline finer than this many seconds
TARGET_COVERAGE = 30   # aim for roughly this many coverage buckets on long videos
MAX_PER_BUCKET = 3     # most frames kept within any single bucket
MIN_GAP = 2.0          # minimum seconds between two kept frames
SETTLE = 0.4           # seconds to advance past a change so the screen settles
MAX_TOTAL = 45         # overall ceiling; thin evenly if exceeded


def main():
    if len(sys.argv) < 2:
        sys.exit("usage: select_frames.py <duration_seconds>  (times on stdin)")
    dur = float(sys.argv[1])
    cand = sorted(float(x) for x in sys.stdin.read().split() if x.strip())

    bucket = max(BUCKET_MIN, dur / TARGET_COVERAGE) if dur > 0 else BUCKET_MIN
    nbuckets = max(1, int(math.ceil(dur / bucket)))

    # 1. Coverage: any bucket with no candidate contributes its midpoint.
    have = set(int(t // bucket) for t in cand)
    for b in range(nbuckets):
        if b not in have:
            cand.append(min(max(dur - 0.5, 0.0), b * bucket + bucket / 2))
    cand.sort()

    # 2+3. Min-gap dedup and per-bucket cap.
    kept, per_bucket, last = [], {}, -1e9
    for t in cand:
        if t - last < MIN_GAP:
            continue
        b = int(t // bucket)
        if per_bucket.get(b, 0) >= MAX_PER_BUCKET:
            continue
        kept.append(t)
        per_bucket[b] = per_bucket.get(b, 0) + 1
        last = t

    # 5. Always represent the first and last of the video.
    forced = [0.0] + ([dur - 1.0] if dur > 1 else [])
    for f in forced:
        if all(abs(f - k) >= MIN_GAP for k in kept):
            kept.append(f)
    kept.sort()

    # Overall ceiling: thin evenly if still too many. Spreading MAX_TOTAL
    # inclusive indices over 0..len-1 keeps both endpoints, so the forced
    # first/last frames survive thinning.
    if len(kept) > MAX_TOTAL:
        step = (len(kept) - 1) / (MAX_TOTAL - 1)
        idx = sorted({round(i * step) for i in range(MAX_TOTAL)})
        kept = [kept[i] for i in idx]

    # 4. Settle offset, clamped into the valid range.
    hi = max(0.0, dur - 0.1)
    seen = set()
    for t in kept:
        out = min(max(t + SETTLE, 0.0), hi)
        key = round(out, 2)
        if key in seen:
            continue
        seen.add(key)
        print(f"{key:.2f}")


if __name__ == "__main__":
    main()
