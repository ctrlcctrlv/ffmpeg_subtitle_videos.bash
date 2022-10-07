#!/usr/bin/jq
($tv[] | .results[-1].alternatives[0].words[0] | to_entries? | [.[] | .key] | @csv) , ($tv[] | .results[-1].alternatives[0].words[] | to_entries? | [.[] | .value?] | @csv)
