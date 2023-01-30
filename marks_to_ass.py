#!/usr/bin/env python3

import datetime
import json
import ass
import sys

_, INP, OUT = sys.argv

marksf_ = open(INP)
marksf = lambda: filter(lambda e: "start" in e, (json.loads(line) for line in marksf_.readlines()))
visemef = lambda: filter(lambda e: e["type"] == "viseme", (json.loads(line) for line in marksf_.readlines()))
assf = ass.Document()
events = ass.EventsSection(assf.EVENTS_HEADER)
jsonf_to_tdelta = lambda s: datetime.timedelta(seconds=float(s))
dialogue = [ass.Dialogue(start = jsonf_to_tdelta(s["start"]), end = jsonf_to_tdelta(s["end"]), text = s["value"], style = s["type"]) for s in list(marksf()) ]
marksf_ = open(INP)
visemes = list()
for d in list(visemef()):
    print(d, file=sys.stderr)
events.set_data(dialogue)
assf.events = events

with open(OUT, 'w+', encoding="utf-8-sig") as f: assf.dump_file(f)
