#!/usr/bin/env python3

import srt
import ass
import sys

_, INP, OUT = sys.argv

with open(INP) as srtf:
    srtf = srtf.read()

srtf = srt.parse(srtf)
assf = ass.Document()
events = ass.EventsSection(assf.EVENTS_HEADER)
dialogue = [ass.Dialogue(start = s.start, end = s.end, text = s.content, style = f'Style{s.proprietary}') for s in srtf]
events.set_data(dialogue)
assf.events = events

with open(OUT, 'w+', encoding="utf-8-sig") as f: assf.dump_file(f)
