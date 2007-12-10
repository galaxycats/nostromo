#!/usr/bin/env bash

for (( i = 0; i < 10; i++ )); do
  convert ./sample_images/640x400.jpg \
          \( +clone -thumbnail 60   -background white  -gravity center -extent 60x45   -quality 80 -write  ./output/THUMB-60-1920-sample.jpg  +delete \) \
          \( +clone -thumbnail 85   -background white  -gravity center -extent 85x63   -quality 80 -write  ./output/THUMB-85-1920-sample.jpg  +delete \) \
          \( +clone -thumbnail 100  -background white  -gravity center -extent 100x75  -quality 80 -write  ./output/THUMB-100-1920-sample.jpg +delete \) \
          \( +clone -thumbnail 240  -background white  -gravity center -extent 240x180 -quality 80 -write  ./output/THUMB-240-1920-sample.jpg +delete \) \
          \( +clone -thumbnail 300  -background white  -gravity center -extent 300x225 -quality 80 -write  ./output/THUMB-300-1920-sample.jpg +delete \) \
                    -thumbnail 640  -background white  -gravity center -extent 640x481 -quality 80         ./output/THUMB-640-1920-sample.jpg
done