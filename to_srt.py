#!/usr/bin/env python3
import datetime, json, srt, sys
from functools import reduce

_, INP, OUT = sys.argv

with open(INP) as f:
    rec = json.load(f)

if 'response' in rec:
    rec = rec['response']

words = rec['results'][-1]['alternatives'][0]['words']
jsonf_to_tdelta = lambda s: datetime.timedelta(seconds=float(s[:-1]))
subs = [srt.Subtitle(None, jsonf_to_tdelta(f['startTime']),
                     jsonf_to_tdelta(f['endTime']), f['word'],
                     str(f['speakerTag']) if 'speakerTag' in f else '') for f
        in words]
subs = srt.sort_and_reindex(subs)

with open(OUT, 'w+') as f:
    print(srt.compose(subs), file=f)
