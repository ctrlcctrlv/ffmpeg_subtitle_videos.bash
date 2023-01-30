# ffmpeg_subtitle_videos.bash

These are the scripts I use to transcribe audio to automatic subtitles like YouTube makes.

E.g. my Watkins cringe videos with the timed text come from these.

Use:
```bash
./transcribe_gcloud_alpha.sh audio.opus audio.json
./to_srt.py audio.json audio.srt 
./srt_to_ass.py audio.srt audio.ass
# $ aegisub audio.ass ← for improving fonts/placement of subs, GUI
#                  AUDIO-FILE VIDEO-OUT SUBTITLES COVERFOTO
./make_overlaid.sh audio.opus video.mkv audio.ass copy.rgba
```
