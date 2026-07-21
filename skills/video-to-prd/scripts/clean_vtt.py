#!/usr/bin/env python3
"""clean_vtt.py — collapse a (possibly rolling) WebVTT caption file into
clean timestamped transcript lines: "[MM:SS] text".

YouTube auto-captions repeat text across overlapping cues; this dedupes them.

Usage: clean_vtt.py <captions.vtt> > transcript.txt
"""
import re
import sys


def parse_ts(ts: str) -> int:
    parts = ts.split(":")
    h, m, s = (["0"] * (3 - len(parts)) + parts)
    return int(h) * 3600 + int(m) * 60 + int(float(s.replace(",", ".")))


def main(path: str) -> None:
    cue_re = re.compile(r"(\d[\d:.,]*)\s-->\s(\d[\d:.,]*)")
    tag_re = re.compile(r"<[^>]+>")

    cues = []  # (start_seconds, text)
    start = None
    lines_buf = []

    def flush():
        nonlocal start, lines_buf
        if start is not None and lines_buf:
            text = " ".join(lines_buf).strip()
            if text:
                cues.append((start, text))
        start, lines_buf = None, []

    with open(path, encoding="utf-8", errors="replace") as f:
        for raw in f:
            line = raw.strip()
            m = cue_re.search(line)
            if m:
                flush()
                start = parse_ts(m.group(1))
            elif not line:
                flush()
            elif start is not None and line not in ("WEBVTT",) and not line.startswith(("Kind:", "Language:", "NOTE")):
                clean = tag_re.sub("", line).replace("&nbsp;", " ").replace("&amp;", "&").strip()
                if clean:
                    lines_buf.append(clean)
    flush()

    # Dedupe rolling captions: drop lines already emitted as the tail of the
    # previous cue's text.
    out = []
    prev_words: list[str] = []
    for ts, text in cues:
        words = text.split()
        # Find the longest suffix of prev_words that is a prefix of words.
        overlap = 0
        max_k = min(len(prev_words), len(words))
        for k in range(max_k, 0, -1):
            if prev_words[-k:] == words[:k]:
                overlap = k
                break
        new_words = words[overlap:]
        if new_words:
            mm, ss = divmod(ts, 60)
            out.append(f"[{mm:02d}:{ss:02d}] {' '.join(new_words)}")
        prev_words = words
    print("\n".join(out))


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("usage: clean_vtt.py <captions.vtt>")
    main(sys.argv[1])
