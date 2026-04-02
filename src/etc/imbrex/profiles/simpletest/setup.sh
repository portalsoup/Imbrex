#!/usr/bin/env bash

composeImage \
  -i "$IMAGES_DIR"/sprite.png \
  -o "$IMAGES_DIR"/itworks3.png \
  -W 1920 -H 1080 \
  -s 200x200 \
  -r 45 \
  -p -220+400

composeImage \
  -i "$IMAGES_DIR"/sprite.png \
  -o "$IMAGES_DIR"/itworks4.png \
  -W 1920 -H 1080 \
  -s 200x200 \
  -r 135 \
  -p -220+400
