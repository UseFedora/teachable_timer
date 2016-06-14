# Super hacky POC code
# this generates an image with a circle around it for every number
# between 0 and 60, then generates a gif from them in tmp/animate.gif

require_relative "lib/gif_timer/clock_number.rb"
require "fileutils"

frames_folder = "tmp/frames"
start_point = 0
end_point = 60
FileUtils.mkdir_p(frames_folder)


# generate the frames
(start_point..end_point).to_a.each do |i|
  GifTimer::ClockNumber.generate(number: i, folder: frames_folder)
end

# combine the frames into one image
frames = (start_point..end_point).to_a.map {|i| "#{frames_folder}/#{i}.gif" }.reverse
image_list = Magick::ImageList.new(*frames)
 # delay 1 second between frames
image_list.delay = 100
# Write gif to file
image_list.write("proof_of_concept.gif")