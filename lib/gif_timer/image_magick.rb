require "rmagick"
module GifTimer
  module ImageMagick
    def self.combine_images(paths:, output_path:)
      `convert #{paths.join(' ')} +append #{output_path}`
    end

    def self.create_gif(frames:, delay:, output_path:)
      `convert -delay #{delay} #{frames.join(' ')} -loop 0 #{output_path}`
    end
  end
end

