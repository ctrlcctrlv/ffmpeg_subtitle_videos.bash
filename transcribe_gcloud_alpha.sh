#!/bin/bash
transcribe_gcloud_alpha() {
	TYPE="${1##*.}"
	FILE="$1"
	[[ "$TYPE" == "opus" || "$TYPE" == "flac" ]] && : || \
		(ffmpeg -i "$FILE" -ac 1 -f opus "${1%%.*}.opus" && \
			FILE="${1%%.*}.opus")
	TYPE="${1##*.}"
	[[ "$TYPE" == "opus" ]] && TYPE=ogg-opus 
	FILEU=$(jq -Rr "@uri" <<< "$FILE")
	>&2 echo "File is $FILE ($FILEU)."
	(gcloud alpha storage cp <(cat "$FILE") "gs://transcribe_random_oneoffs/$FILEU") &&
	gcloud alpha ml speech recognize-long-running --encoding="$TYPE" --sample-rate=48000 --enable-automatic-punctuation --include-word-time-offsets --model=video_enhanced --language-code=en-US --enable-speaker-diarization "gs://transcribe_random_oneoffs/$FILEU" $3 > "$2"
}

transcribe_gcloud_alpha "$@"

