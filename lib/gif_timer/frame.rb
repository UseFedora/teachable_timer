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
      image_list = combine_images(component_image_paths)
      image_list.write(path)
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

      total_hours = (time_difference_without_seconds/60 - parts[:minutes]) / 60
      parts[:hours] = total_hours % 24
      parts[:days] = (total_hours - parts[:hours])/24
      parts
    end

    def component_image_paths
      timer_part_image_paths = time_parts.map do |part, time|
        "#{COMPONENT_FOLDER}/#{part}/#{time.to_i}.#{COMPONENT_FORMAT}"
      end
    end

    # Combine an array of images from left to right
    def combine_images(image_paths=[])
      image_row = Magick::ImageList.new
      image_canvas = Magick::ImageList.new
      image_paths.each do |path|
        image = Magick::Image.read(path).first
        image_row.push(image)
      end
      image_canvas.push(image_row.append(false))
    end
  end
end
