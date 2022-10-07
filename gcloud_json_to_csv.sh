#!/bin/bash
JSON=$1
CSV=${JSON%.*}.csv
jq --slurpfile tv <(jq < "$JSON") -r "$(cat gcloud_json_to_csv.jq)" < "$JSON" > "$CSV"
