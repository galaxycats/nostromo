#!/usr/bin/env ruby

require 'rubygems'
require 'benchmark'
require 'RMagick'


puts '###########################################'
puts '# BENCHMARKING IMAGE PROCESSING WITH RUBY #'
puts '###########################################'
puts
puts "Preparing benchmark ..."
puts

IMAGE_SIZE_THUMB                 = 60
IMAGE_SIZE_THUMB_LIST            = 85
IMAGE_SIZE_TOPOFFERED            = 100
IMAGE_SIZE_TOPOFFERED_BIG        = 240
IMAGE_SIZE_BIG                   = 300
IMAGE_SIZE_XXL                   = 640
VALID_THUMB_SIZES                = [IMAGE_SIZE_THUMB, IMAGE_SIZE_THUMB_LIST, IMAGE_SIZE_TOPOFFERED, IMAGE_SIZE_TOPOFFERED_BIG, IMAGE_SIZE_BIG, IMAGE_SIZE_XXL]

# Method for generating the Image
def create_thumbnail(image, size)
  thumbnail = image.change_geometry("#{size}x#{(size/1.33).to_i}") { |cols, rows, img| img.resize(cols, rows) }
  thumbnail.border!(150,150,"#ffffff")
  thumbnail.crop!(Magick::CenterGravity,size,(size/1.33).to_i)
  thumbnail.write(File.join(File.dirname(__FILE__) + "/output/THUMB-#{size}_#{image.base_filename.split('/').last}"))
end

n = 50
puts "Performing Benchmark with #{n} runs ... (Ruby Wrapper Call)"
puts
Benchmark.bmbm(10) do |x|
  x.report("1920x1200 Image") do
    n.times do
      image_1920 = Magick::Image.read(File.dirname(__FILE__) + '/sample_images/1920x1200.jpg').first
      VALID_THUMB_SIZES.each { |size| create_thumbnail(image_1920, size) }
    end
  end
  x.report("1600x1000 Image") do
    n.times do
      image_1600 = Magick::Image.read(File.dirname(__FILE__) + '/sample_images/1600x1000.jpg').first
      VALID_THUMB_SIZES.each { |size| create_thumbnail(image_1600, size) }
    end
  end
  x.report("1280x800 Image") do
    n.times do 
      image_1280 = Magick::Image.read(File.dirname(__FILE__) + '/sample_images/1280x800.jpg').first
      VALID_THUMB_SIZES.each { |size| create_thumbnail(image_1280, size) }
    end
  end
  x.report("1024x640 Image") do
    n.times do
      image_1024 = Magick::Image.read(File.dirname(__FILE__) + '/sample_images/1024x640.jpg').first
      VALID_THUMB_SIZES.each { |size| create_thumbnail(image_1024, size) }
    end
  end
  x.report("800x500 Image") do
    n.times do
      image_800 = Magick::Image.read(File.dirname(__FILE__) + '/sample_images/800x500.jpg').first
      VALID_THUMB_SIZES.each { |size| create_thumbnail(image_800, size) }
    end
  end
  x.report("640x400 Image") do
    n.times do
      image_640 = Magick::Image.read(File.dirname(__FILE__) + '/sample_images/640x400.jpg').first
      VALID_THUMB_SIZES.each { |size| create_thumbnail(image_640, size) }
    end
  end
end


# System Call
# Resize:
# convert '*.jpg[120x120]' thumbnail%03d.png
# convert '*.jpg' -resize 120x120 thumbnail%03d.png
# Crop:
# convert '*.jpg[120x120+10+5]' thumbnail%03d.png
# convert '*.jpg' -crop 120x120+10+5 thumbnail%03d.png
# Border
# convert '*.jpg' -border 150

# convert_args_1920 = 'convert ./sample_images/1920x1200.jpg \
#         \( +clone -thumbnail 60   -background white  -gravity center -extent 60x45   -quality 80 -write  ./output/THUMB-60-1920-sample.jpg  +delete \) \
#         \( +clone -thumbnail 85   -background white  -gravity center -extent 85x63   -quality 80 -write  ./output/THUMB-85-1920-sample.jpg  +delete \) \
#         \( +clone -thumbnail 100  -background white  -gravity center -extent 100x75  -quality 80 -write  ./output/THUMB-100-1920-sample.jpg +delete \) \
#         \( +clone -thumbnail 240  -background white  -gravity center -extent 240x180 -quality 80 -write  ./output/THUMB-240-1920-sample.jpg +delete \) \
#         \( +clone -thumbnail 300  -background white  -gravity center -extent 300x225 -quality 80 -write  ./output/THUMB-300-1920-sample.jpg +delete \) \
#                   -thumbnail 640  -background white  -gravity center -extent 640x481 -quality 80         ./output/THUMB-640-1920-sample.jpg'
# convert_args_1600 = 'convert ./sample_images/1600x1000.jpg \
#         \( +clone -thumbnail 60   -background white  -gravity center -extent 60x45   -quality 80 -write  ./output/THUMB-60-1600-sample.jpg  +delete \) \
#         \( +clone -thumbnail 85   -background white  -gravity center -extent 85x63   -quality 80 -write  ./output/THUMB-85-1600-sample.jpg  +delete \) \
#         \( +clone -thumbnail 100  -background white  -gravity center -extent 100x75  -quality 80 -write  ./output/THUMB-100-1600-sample.jpg +delete \) \
#         \( +clone -thumbnail 240  -background white  -gravity center -extent 240x180 -quality 80 -write  ./output/THUMB-240-1600-sample.jpg +delete \) \
#         \( +clone -thumbnail 300  -background white  -gravity center -extent 300x225 -quality 80 -write  ./output/THUMB-300-1600-sample.jpg +delete \) \
#                   -thumbnail 640  -background white  -gravity center -extent 640x481 -quality 80         ./output/THUMB-640-1600-sample.jpg'
# convert_args_1280 = 'convert ./sample_images/1280x800.jpg \
#         \( +clone -thumbnail 60   -background white  -gravity center -extent 60x45   -quality 80 -write  ./output/THUMB-60-1280-sample.jpg  +delete \) \
#         \( +clone -thumbnail 85   -background white  -gravity center -extent 85x63   -quality 80 -write  ./output/THUMB-85-1280-sample.jpg  +delete \) \
#         \( +clone -thumbnail 100  -background white  -gravity center -extent 100x75  -quality 80 -write  ./output/THUMB-100-1280-sample.jpg +delete \) \
#         \( +clone -thumbnail 240  -background white  -gravity center -extent 240x180 -quality 80 -write  ./output/THUMB-240-1280-sample.jpg +delete \) \
#         \( +clone -thumbnail 300  -background white  -gravity center -extent 300x225 -quality 80 -write  ./output/THUMB-300-1280-sample.jpg +delete \) \
#                   -thumbnail 640  -background white  -gravity center -extent 640x481 -quality 80         ./output/THUMB-640-1280-sample.jpg'
# convert_args_1024 = 'convert ./sample_images/1024x640.jpg \
#         \( +clone -thumbnail 60   -background white  -gravity center -extent 60x45   -quality 80 -write  ./output/THUMB-60-1024-sample.jpg  +delete \) \
#         \( +clone -thumbnail 85   -background white  -gravity center -extent 85x63   -quality 80 -write  ./output/THUMB-85-1024-sample.jpg  +delete \) \
#         \( +clone -thumbnail 100  -background white  -gravity center -extent 100x75  -quality 80 -write  ./output/THUMB-100-1024-sample.jpg +delete \) \
#         \( +clone -thumbnail 240  -background white  -gravity center -extent 240x180 -quality 80 -write  ./output/THUMB-240-1024-sample.jpg +delete \) \
#         \( +clone -thumbnail 300  -background white  -gravity center -extent 300x225 -quality 80 -write  ./output/THUMB-300-1024-sample.jpg +delete \) \
#                   -thumbnail 640  -background white  -gravity center -extent 640x481 -quality 80         ./output/THUMB-640-1024-sample.jpg'
# convert_args_800  = 'convert ./sample_images/800x500.jpg \
#         \( +clone -thumbnail 60   -background white  -gravity center -extent 60x45   -quality 80 -write  ./output/THUMB-60-800-sample.jpg  +delete \) \
#         \( +clone -thumbnail 85   -background white  -gravity center -extent 85x63   -quality 80 -write  ./output/THUMB-85-800-sample.jpg  +delete \) \
#         \( +clone -thumbnail 100  -background white  -gravity center -extent 100x75  -quality 80 -write  ./output/THUMB-100-800-sample.jpg +delete \) \
#         \( +clone -thumbnail 240  -background white  -gravity center -extent 240x180 -quality 80 -write  ./output/THUMB-240-800-sample.jpg +delete \) \
#         \( +clone -thumbnail 300  -background white  -gravity center -extent 300x225 -quality 80 -write  ./output/THUMB-300-800-sample.jpg +delete \) \
#                   -thumbnail 640  -background white  -gravity center -extent 640x481 -quality 80         ./output/THUMB-640-800-sample.jpg'
# convert_args_640  = 'convert ./sample_images/640x400.jpg \
#         \( +clone -thumbnail 60   -background white  -gravity center -extent 60x45   -quality 80 -write  ./output/THUMB-60-640-sample.jpg  +delete \) \
#         \( +clone -thumbnail 85   -background white  -gravity center -extent 85x63   -quality 80 -write  ./output/THUMB-85-640-sample.jpg  +delete \) \
#         \( +clone -thumbnail 100  -background white  -gravity center -extent 100x75  -quality 80 -write  ./output/THUMB-100-640-sample.jpg +delete \) \
#         \( +clone -thumbnail 240  -background white  -gravity center -extent 240x180 -quality 80 -write  ./output/THUMB-240-640-sample.jpg +delete \) \
#         \( +clone -thumbnail 300  -background white  -gravity center -extent 300x225 -quality 80 -write  ./output/THUMB-300-640-sample.jpg +delete \) \
#                   -thumbnail 640  -background white  -gravity center -extent 640x481 -quality 80         ./output/THUMB-640-640-sample.jpg'
# 
# puts
# puts "Performing Benchmark with #{n} runs ... (System Call)"
# puts
# Benchmark.bmbm(10) do |x|
#   x.report("1920x1200 Image") { n.times { VALID_THUMB_SIZES.each { |size| system(convert_args_1920) } } }
#   x.report("1600x1000 Image") { n.times { VALID_THUMB_SIZES.each { |size| system(convert_args_1600) } } }
#   x.report("1280x800 Image")  { n.times { VALID_THUMB_SIZES.each { |size| system(convert_args_1280) } } }
#   x.report("1024x640 Image")  { n.times { VALID_THUMB_SIZES.each { |size| system(convert_args_1024) } } }
#   x.report("800x500 Image")   { n.times { VALID_THUMB_SIZES.each { |size| system(convert_args_800) } } }
#   x.report("640x400 Image")   { n.times { VALID_THUMB_SIZES.each { |size| system(convert_args_640) } } }
# end

puts
puts "Finished benchmarking!"