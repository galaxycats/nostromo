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
IMAGE_SIZE_THUMB_DETAIL_VIEW     = 85
IMAGE_SIZE_TOPOFFERED            = 100
IMAGE_SIZE_TOPOFFERED_BIG        = 240
IMAGE_SIZE_BIG                   = 300
IMAGE_SIZE_XXL                   = 640
VALID_THUMB_SIZES                = [IMAGE_SIZE_THUMB, IMAGE_SIZE_THUMB_LIST, IMAGE_SIZE_TOPOFFERED, IMAGE_SIZE_TOPOFFERED_BIG, IMAGE_SIZE_BIG, IMAGE_SIZE_XXL]
# VALID_THUMB_SIZES                = [IMAGE_SIZE_XXL]


image_1920 = Magick::Image.read(File.dirname(__FILE__) + '/sample_images/1920x1200.jpg').first
image_1600 = Magick::Image.read(File.dirname(__FILE__) + '/sample_images/1600x1000.jpg').first
image_1280 = Magick::Image.read(File.dirname(__FILE__) + '/sample_images/1280x800.jpg').first
image_1024 = Magick::Image.read(File.dirname(__FILE__) + '/sample_images/1024x640.jpg').first
image_800  = Magick::Image.read(File.dirname(__FILE__) + '/sample_images/800x500.jpg').first
image_640  = Magick::Image.read(File.dirname(__FILE__) + '/sample_images/640x400.jpg').first

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
  x.report("1920x1200 Image") { n.times { VALID_THUMB_SIZES.each { |size| create_thumbnail(image_1920, size) } } }
  x.report("1600x1000 Image") { n.times { VALID_THUMB_SIZES.each { |size| create_thumbnail(image_1600, size) } } }
  x.report("1280x800 Image")  { n.times { VALID_THUMB_SIZES.each { |size| create_thumbnail(image_1280, size) } } }
  x.report("1024x640 Image")  { n.times { VALID_THUMB_SIZES.each { |size| create_thumbnail(image_1024, size) } } }
  x.report("800x500 Image")   { n.times { VALID_THUMB_SIZES.each { |size| create_thumbnail(image_800, size) } } }
  x.report("640x400 Image")   { n.times { VALID_THUMB_SIZES.each { |size| create_thumbnail(image_640, size) } } }
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

puts
puts "Performing Benchmark with #{n} runs ... (System Call)"
puts
Benchmark.bmbm(10) do |x|
  x.report("1920x1200 Image") { n.times { VALID_THUMB_SIZES.each { |size| create_thumbnail(image_1920, size) } } }
  x.report("1600x1000 Image") { n.times { VALID_THUMB_SIZES.each { |size| create_thumbnail(image_1600, size) } } }
  x.report("1280x800 Image")  { n.times { VALID_THUMB_SIZES.each { |size| create_thumbnail(image_1280, size) } } }
  x.report("1024x640 Image")  { n.times { VALID_THUMB_SIZES.each { |size| create_thumbnail(image_1024, size) } } }
  x.report("800x500 Image")   { n.times { VALID_THUMB_SIZES.each { |size| create_thumbnail(image_800, size) } } }
  x.report("640x400 Image")   { n.times { VALID_THUMB_SIZES.each { |size| create_thumbnail(image_640, size) } } }
end

puts
puts "Finished benchmarking!"