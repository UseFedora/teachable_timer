# Super hacky POC code
# this generates an image with a circle around it for every number
# between 0 and 60, then generates a gif from them in tmp/animate.gif

require "fileutils"

def combine_images(image_paths=[])
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

def create_durations(duration_in_seconds, frames: 60)
  (1..frames).to_a.map do |offset|
    time_parts(duration_in_seconds - offset)
  end
end

# durations = {:days=>27, :hours=>23, :minutes=>57, :seconds=>11},
#  {:days=>27, :hours=>23, :minutes=>57, :seconds=>10},
#  {:days=>27, :hours=>23, :minutes=>57, :seconds=>9},
#  {:days=>27, :hours=>23, :minutes=>57, :seconds=>3},
#  {:days=>27, :hours=>23, :minutes=>57, :seconds=>2},
#  {:days=>27, :hours=>23, :minutes=>57, :seconds=>1},


def create_gif(start_time:, end_time:, output_path:, frames: 60)
  time_difference = end_time - start_time
  durations = create_durations(time_difference, frames: frames)
  image_parts = durations.map do |duration|
    duration.map do |part, time|
      "./frames/#{part}/#{time.to_i}.gif"
    end
  end

  FileUtils.mkdir_p("./tmp/combined/")
  image_parts.each_with_index do |image_array, index|
    image_list = combine_images(image_array)
    image_list.write("./tmp/combined/#{index}.gif")
  end
  frames = (0...frames).to_a.map {|i| "./tmp/combined/#{i}.gif" }
  image_list = Magick::ImageList.new(*frames)
   # delay 1 second between frames
  image_list.delay = 100

  # Write gif to file
  image_list = image_list.optimize_layers(Magick::OptimizeLayer)
  image_list.write(output_path)
end

# end_time = Time.now + 180
# start_time = Time.now
# output_path = "proof_of_concept.gif"
# create_gif(start_time: start_time, end_time: end_time, output_path: output_path)