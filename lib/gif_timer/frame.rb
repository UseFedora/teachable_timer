require "rmagick"
module GifTimer
  class Frame
    attr_reader :time_difference
    FRAME_FOLDER = "./tmp/frames"
    COMPONENT_FOLDER = "./timer_parts"
    COMPONENT_FORMAT="png"

    def initialize(time_difference)
      @time_difference = time_difference
    end

    def self.find_or_create(time_difference)
      frame = new(time_difference)
      frame.save unless frame.exist?
      frame
    end

    def save
      ImageMagick.combine_images(paths: component_image_paths, output_path: path)
    end

    def path
      "#{FRAME_FOLDER}/#{file_name}.gif"
    end

    def exist?
      File.exist?(path)
    end

    private

    def file_name
      sprintf('%06d', @time_difference)
    end

    # Convert a time_difference into a hash in the format of {days:,hours:,minutes:, seconds:}
    def time_parts
      parts = {
        days: 0,
        hours: 0,
        minutes: 0,
        seconds: 0
      }
      parts[:seconds] = @time_difference % 60
      time_difference_without_seconds = @time_difference - parts[:seconds]
      parts[:minutes] = (time_difference_without_seconds/60) % 60
      parts[:minutes] = 0 if parts[:minutes] < 0
      total_hours = (time_difference_without_seconds/60 - parts[:minutes]) / 60
      parts[:hours] = total_hours % 24
      parts[:hours] = 0 if parts[:hours] < 0
      parts[:days] = (total_hours - parts[:hours])/24
      parts[:days] = 0 if parts[:days] < 0
      parts
    end

    def component_image_paths
      timer_part_image_paths = time_parts.map do |part, time|
        "#{COMPONENT_FOLDER}/#{part}/#{time.to_i}.#{COMPONENT_FORMAT}"
      end
    end
  end
end
