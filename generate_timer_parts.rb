#generate the frames
require "fileutils"
require_relative "lib/gif_timer"

CLOCK_PARTS = [
  {
    caption_text: "seconds",
    max: 60
  },
  {
    caption_text: "minutes",
    max: 60
  },
  {
    caption_text: "hours",
    max: 24
  },
  {
    caption_text: "days",
    max: 30,
    force_circle: true
  }
]

CLOCK_PARTS.each do |timer_part_options|
  frames_folder = "timer_parts/#{timer_part_options[:caption_text]}"
  FileUtils.mkdir_p(frames_folder)

  timer_part_options.merge!(number: i, folder: frames_folder)

  GifTimer::TimerPart.new(timer_part_options).save
end
