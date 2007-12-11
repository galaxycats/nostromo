#!/usr/bin/env bash

for (( i = 0; i < 50; i++ )); do
  convert ./sample_images/1920x1200.jpg \
          \( +clone -thumbnail 60   -background white  -gravity center -extent 60x45   -quality 80 -write  ./output/THUMB-60-1920-sample.jpg  +delete \) \
          \( +clone -thumbnail 85   -background white  -gravity center -extent 85x63   -quality 80 -write  ./output/THUMB-85-1920-sample.jpg  +delete \) \
          \( +clone -thumbnail 100  -background white  -gravity center -extent 100x75  -quality 80 -write  ./output/THUMB-100-1920-sample.jpg +delete \) \
          \( +clone -thumbnail 240  -background white  -gravity center -extent 240x180 -quality 80 -write  ./output/THUMB-240-1920-sample.jpg +delete \) \
          \( +clone -thumbnail 300  -background white  -gravity center -extent 300x225 -quality 80 -write  ./output/THUMB-300-1920-sample.jpg +delete \) \
                    -thumbnail 640  -background white  -gravity center -extent 640x481 -quality 80         ./output/THUMB-640-1920-sample.jpg
done

for (( i = 0; i < 50; i++ )); do
  convert ./sample_images/1600x1000.jpg \
          \( +clone -thumbnail 60   -background white  -gravity center -extent 60x45   -quality 80 -write  ./output/THUMB-60-1600-sample.jpg  +delete \) \
          \( +clone -thumbnail 85   -background white  -gravity center -extent 85x63   -quality 80 -write  ./output/THUMB-85-1600-sample.jpg  +delete \) \
          \( +clone -thumbnail 100  -background white  -gravity center -extent 100x75  -quality 80 -write  ./output/THUMB-100-1600-sample.jpg +delete \) \
          \( +clone -thumbnail 240  -background white  -gravity center -extent 240x180 -quality 80 -write  ./output/THUMB-240-1600-sample.jpg +delete \) \
          \( +clone -thumbnail 300  -background white  -gravity center -extent 300x225 -quality 80 -write  ./output/THUMB-300-1600-sample.jpg +delete \) \
                    -thumbnail 640  -background white  -gravity center -extent 640x481 -quality 80         ./output/THUMB-640-1600-sample.jpg
done

for (( i = 0; i < 50; i++ )); do
  convert ./sample_images/1280x800.jpg \
          \( +clone -thumbnail 60   -background white  -gravity center -extent 60x45   -quality 80 -write  ./output/THUMB-60-1280-sample.jpg  +delete \) \
          \( +clone -thumbnail 85   -background white  -gravity center -extent 85x63   -quality 80 -write  ./output/THUMB-85-1280-sample.jpg  +delete \) \
          \( +clone -thumbnail 100  -background white  -gravity center -extent 100x75  -quality 80 -write  ./output/THUMB-100-1280-sample.jpg +delete \) \
          \( +clone -thumbnail 240  -background white  -gravity center -extent 240x180 -quality 80 -write  ./output/THUMB-240-1280-sample.jpg +delete \) \
          \( +clone -thumbnail 300  -background white  -gravity center -extent 300x225 -quality 80 -write  ./output/THUMB-300-1280-sample.jpg +delete \) \
                    -thumbnail 640  -background white  -gravity center -extent 640x481 -quality 80         ./output/THUMB-640-1280-sample.jpg
done

for (( i = 0; i < 50; i++ )); do
  convert ./sample_images/1024x640.jpg \
          \( +clone -thumbnail 60   -background white  -gravity center -extent 60x45   -quality 80 -write  ./output/THUMB-60-1024-sample.jpg  +delete \) \
          \( +clone -thumbnail 85   -background white  -gravity center -extent 85x63   -quality 80 -write  ./output/THUMB-85-1024-sample.jpg  +delete \) \
          \( +clone -thumbnail 100  -background white  -gravity center -extent 100x75  -quality 80 -write  ./output/THUMB-100-1024-sample.jpg +delete \) \
          \( +clone -thumbnail 240  -background white  -gravity center -extent 240x180 -quality 80 -write  ./output/THUMB-240-1024-sample.jpg +delete \) \
          \( +clone -thumbnail 300  -background white  -gravity center -extent 300x225 -quality 80 -write  ./output/THUMB-300-1024-sample.jpg +delete \) \
                    -thumbnail 640  -background white  -gravity center -extent 640x481 -quality 80         ./output/THUMB-640-1024-sample.jpg
done

for (( i = 0; i < 50; i++ )); do
  convert ./sample_images/800x500.jpg \
          \( +clone -thumbnail 60   -background white  -gravity center -extent 60x45   -quality 80 -write  ./output/THUMB-60-800-sample.jpg  +delete \) \
          \( +clone -thumbnail 85   -background white  -gravity center -extent 85x63   -quality 80 -write  ./output/THUMB-85-800-sample.jpg  +delete \) \
          \( +clone -thumbnail 100  -background white  -gravity center -extent 100x75  -quality 80 -write  ./output/THUMB-100-800-sample.jpg +delete \) \
          \( +clone -thumbnail 240  -background white  -gravity center -extent 240x180 -quality 80 -write  ./output/THUMB-240-800-sample.jpg +delete \) \
          \( +clone -thumbnail 300  -background white  -gravity center -extent 300x225 -quality 80 -write  ./output/THUMB-300-800-sample.jpg +delete \) \
                    -thumbnail 640  -background white  -gravity center -extent 640x481 -quality 80         ./output/THUMB-640-800-sample.jpg
done

for (( i = 0; i < 50; i++ )); do
  convert ./sample_images/640x400.jpg \
          \( +clone -thumbnail 60   -background white  -gravity center -extent 60x45   -quality 80 -write  ./output/THUMB-60-640-sample.jpg  +delete \) \
          \( +clone -thumbnail 85   -background white  -gravity center -extent 85x63   -quality 80 -write  ./output/THUMB-85-640-sample.jpg  +delete \) \
          \( +clone -thumbnail 100  -background white  -gravity center -extent 100x75  -quality 80 -write  ./output/THUMB-100-640-sample.jpg +delete \) \
          \( +clone -thumbnail 240  -background white  -gravity center -extent 240x180 -quality 80 -write  ./output/THUMB-240-640-sample.jpg +delete \) \
          \( +clone -thumbnail 300  -background white  -gravity center -extent 300x225 -quality 80 -write  ./output/THUMB-300-640-sample.jpg +delete \) \
                    -thumbnail 640  -background white  -gravity center -extent 640x481 -quality 80         ./output/THUMB-640-640-sample.jpg
done

