#!/usr/bin/env bash

# -1 = midnight, 1 = noon
dayCycleCos=$(dailyWave)

# normalize the range from -1..1, to 0..100
normalizedRange=$(normalizeRange \
  -v "$dayCycleCos" \
  -s -1 -S 1 \
  -t 0 -t 100\
)

# Generate a gradient that changes intensity with the day
createGradient \
  -i "$normalizedRange" \
  -b "#0000FF" \
  -t "#FF5000" \
  -w 1920 -h 1080 \
  -r -90 \
  -o "$IMAGES_DIR"/gradient.png


# Place an image at a specific location
composeImage \
  -i "$IMAGES_DIR"/sprite.png \
  -o "$IMAGES_DIR"/itworks3.png \
  -W 1920 -H 1080 \
  -s 200x200 \
  -r 45 \
  -p +0+400

composeImage \
  -i "$IMAGES_DIR"/sprite.png \
  -o "$IMAGES_DIR"/itworks4.png \
  -W 1920 -H 1080 \
  -s 200x200 \
  -r 135 \
  -p +0+400
