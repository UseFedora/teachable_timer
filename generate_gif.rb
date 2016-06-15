# Super hacky POC code
# this generates an image with a circle around it for every number
# between 0 and 60, then generates a gif from them in tmp/animate.gif

require_relative "lib/gif_timer/clock_number.rb"
require "fileutils"


start_point = 0
end_point = 99
caption_text = "seconds"

captions = [:days, :hours, :minutes, :seconds]

# generate the frames
# caption_text = "seconds"
# frames_folder = "tmp/frames/#{caption_text}"
# FileUtils.mkdir_p(frames_folder)
# end_point = 60
# start_point = 0
# (start_point..end_point).to_a.each do |i|
#   generator = GifTimer::ClockNumber.new(number: i, max: end_point, caption_text: caption_text, fill: "gray")
#   generator.generate_image(folder: frames_folder)
# end

# caption_text = "minutes"
# frames_folder = "tmp/frames/#{caption_text}"
# FileUtils.mkdir_p(frames_folder)
# end_point = 60
# start_point = 0
# (start_point..end_point).to_a.each do |i|
#   generator = GifTimer::ClockNumber.new(number: i, max: end_point, caption_text: caption_text, fill: "gray")
#   generator.generate_image(folder: frames_folder)
# end

# caption_text = "hours"
# frames_folder = "tmp/frames/#{caption_text}"
# FileUtils.mkdir_p(frames_folder)
# end_point = 24
# start_point = 0
# (start_point..end_point).to_a.each do |i|
#   generator = GifTimer::ClockNumber.new(number: i, max: end_point, caption_text: caption_text, fill: "gray")
#   generator.generate_image(folder: frames_folder)
# end

# caption_text = "days"
# frames_folder = "tmp/frames/#{caption_text}"
# FileUtils.mkdir_p(frames_folder)
# end_point = 99
# start_point = 0
# (start_point..end_point).to_a.each do |i|
#   generator = GifTimer::ClockNumber.new(number: i, max: end_point, caption_text: caption_text, fill: "gray")
#   generator.generate_image(folder: frames_folder)
# end


#GifTimer::ClockNumber.generate(number: i, folder: frames_folder)
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


=begin
durations = {:days=>27, :hours=>23, :minutes=>57, :seconds=>11},
 {:days=>27, :hours=>23, :minutes=>57, :seconds=>10},
 {:days=>27, :hours=>23, :minutes=>57, :seconds=>9},
 {:days=>27, :hours=>23, :minutes=>57, :seconds=>3},
 {:days=>27, :hours=>23, :minutes=>57, :seconds=>2},
 {:days=>27, :hours=>23, :minutes=>57, :seconds=>1},
=end

end_time = Time.now + 60*60*24*28+10
begin_time = Time.now
diff_time = end_time - begin_time

durations = create_durations(diff_time)

image_parts = durations.map do |duration|

  # {:days=>27, :hours=>23, :minutes=>57, :seconds=>1}
  duration.map do |part, time|
    "frames/#{part}/#{time.to_i}.gif"
  end
end

FileUtils.mkdir_p("combined/")
image_parts.each_with_index do |image_array, index|
  image_list = combine_images(image_array)
  image_list.write("combined/#{index}.gif")
end
frames = (0..59).to_a.map {|i| "combined/#{i}.gif" }
image_list = Magick::ImageList.new(*frames)
 # delay 1 second between frames
image_list.delay = 100
# Write gif to file
image_list = image_list.optimize_layers(Magick::OptimizeLayer)
image_list.write("proof_of_concept.gif")

