#generate the frames
require "fileutils"
require_relative "lib/gif_timer/clock_number.rb"

CLOCK_PARTS = [
  {
    caption_text: "seconds",
    start_point: 0,
    end_point: 60
  },
  {
    caption_text: "minutes",
    start_point: 0,
    end_point: 60
  },
  {
    caption_text: "hours",
    start_point: 0,
    end_point: 24
  },
  {
    caption_text: "days",
    start_point: 0,
    end_point: 99
  }
]

def generate_clock_parts(clock_part)
  frames_folder = "frames/#{clock_part[:caption_text]}"
  FileUtils.mkdir_p(frames_folder)
  (clock_part[:start_point]..clock_part[:end_point]).to_a.each do |i|
    generator = GifTimer::ClockNumber.new(number: i,
      max: clock_part[:end_point],
      caption_text: clock_part[:caption_text],
      fill: "gray"
    )
    generator.generate_image(folder: frames_folder)
  end
end

CLOCK_PARTS.each do |clock_part|
  generate_clock_parts(clock_part)
end
