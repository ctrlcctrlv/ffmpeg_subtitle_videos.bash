#!/bin/bash
transcribe_gcloud_alpha() {
	gcloud alpha storage cp "$1" gs://transcribe_random_oneoffs/ &&
	gcloud alpha ml speech recognize-long-running --enable-automatic-punctuation --include-word-time-offsets --model=video_enhanced --encoding=flac --language-code=en-US --sample-rate=48000 --enable-speaker-diarization "gs://transcribe_random_oneoffs/$1" > "$2"
}

transcribe_gcloud_alpha $@
