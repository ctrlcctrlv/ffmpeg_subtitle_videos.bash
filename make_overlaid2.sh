#!/bin/bash
AUDIO="${AUDIO:=$1}"
OUTPUT="${OUTPUT:=$2}"
SUBS="${SUBS:=$3}"
[ -z "$SUBS" ] && SUBS=subs.ass
OVERLAY="${OVERLAY:=$4}"
[ -z "$OVERLAY" ] && OVERLAY=copy.rgba

hash gm && IM='gm convert' || IM='convert'

if perl -pe 'exit(!/\.rgba$/)' <<< "$OVERLAY"; then
    RGBA="${OVERLAY%.*}.rgba"
    ${IM} "$OVERLAY" "$RGBA" && OVERLAY="$RGBA"
fi

if perl -pe 'exit(!/\.srt$/)' <<< "$SUBS"; then
    ASS="${SUBS%.*}.ass"
    ffmpeg -c:s srt -i "$SUBS" -c:s ass "$ASS" && SUBS="$ASS"
fi

if hash nvidia-detector; then
    export __NV_PRIME_RENDER_OFFLOAD=1 
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    CODEC=nvenc
else
    CODEC=vaapi
fi

ffmpeg \
    -i "$AUDIO" -pix_fmt rgba -video_size 1920x1080 -f rawvideo \
    -i "$OVERLAY" \
    -filter_complex \
        "[0:v]scale=w=720:h=-1[vid]; [1:v]scale=w=720:h=-1,colorchannelmixer=aa=0.5[bg]; [vid][bg]overlay=shortest=0:format=rgb,ass=$SUBS" \
    -c:a aac -c:v h264_$CODEC "$OUTPUT"
