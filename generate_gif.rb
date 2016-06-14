# Super hacky POC code
# this generates an image with a circle around it for every number
# between 0 and 60, then generates a gif from them in tmp/animate.gif

require_relative "lib/gif_timer/clock_number.rb"
require "fileutils"


start_point = 0
end_point = 99
caption_text = "days"

frames_folder = "tmp/frames/#{caption_text}"
FileUtils.mkdir_p(frames_folder)

# generate the frames
(start_point..end_point).to_a.each do |i|
  generator = GifTimer::ClockNumber.new(number: i, max: i)
  generator.generate_image(folder: frames_folder)
  #GifTimer::ClockNumber.generate(number: i, folder: frames_folder)
end

# combine the frames into one image
=begin
frames = (start_point..end_point).to_a.map {|i| "#{frames_folder}/#{i}.gif" }.reverse
image_list = Magick::ImageList.new(*frames)
 # delay 1 second between frames
image_list.delay = 100
# Write gif to file
image_list.write("proof_of_concept.gif")
=end



def combine_images(image_paths=["tmp/0.gif","tmp/1.gif"])
  image_row = Magick::ImageList.new
  image_canvas = Magick::ImageList.new
  image_paths.each do |path|
    image = Magick::Image.read(path).first
    image_row.push(image)
  end
  image_canvas.push(image_row.append(false))
end







def time_parts(duration_in_seconds)
  parts = {
    days: 0,
    hours: 0,
    minutes: 0,
    seconds: 0
  }
  parts[:seconds] = duration_in_seconds % 60
  duration_without_seconds = duration_in_seconds - parts[:seconds]
  parts[:minutes] = (duration_without_seconds/60) % 60

  total_hours = (duration_without_seconds/60 - parts[:minutes]) / 60
  parts[:hours] = total_hours % 24
  parts[:days] = (total_hours - parts[:hours])/24
  parts
end

def create_durations(duration_in_seconds=7261, frames: 60)
  (1..frames).to_a.map do |offset|
    time_parts(duration_in_seconds - offset)
  end
end
