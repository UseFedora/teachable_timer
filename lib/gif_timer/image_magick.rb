require "rmagick"
module GifTimer
  module ImageMagick


    def self.combine_images(paths:, output_path:)
      `convert #{paths.join(' ')} +append #{output_path}`
      # image_row = Magick::ImageList.new
      # image_canvas = Magick::ImageList.new
      # image_paths.each do |path|
      #   image = Magick::Image.read(path).first
      #   image_row.push(image)
      # end
      # image_canvas.push(image_row.append(false))
      # image_list.write(output_path)
    end

    def self.create_gif(frames:, delay:, output_path:)
      `convert -delay #{delay} #{frames.join(' ')} -loop 0 #{output_path}`
      # image_list = Magick::ImageList.new(*frames)
      # image_list.delay = delay
      # image_list.write(output_path)
    end
  end
end

