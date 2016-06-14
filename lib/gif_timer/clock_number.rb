require "rmagick"
module GifTimer
  class ClockNumber
    attr_reader :canvas, :width, :height, :font_family, :fill, :point_size, :text
    def initialize(background_color: "white",
                   width: 250,
                   height: 250,
                   number: 12,
                   max: 60,
                   font_family: "helvetica",
                   point_size: 32,
                   fill: "blue"
                   )
      @width = width
      @height = height
      @number = number
      @text = number.to_s
      @percent_complete = number.to_f/max
      @font_family = font_family
      @point_size = point_size
      @fill = fill
      @canvas = Magick::ImageList.new
      @canvas.new_image(width, height)
    end

    def self.generate(number:, folder:)
      image = new(number: number)
      image.generate_image(folder: folder)
    end

    def generate_image(folder:)
      add_text_layer
      add_circle if @number > 0
      canvas.write("#{folder}/#{@number}.gif")
    end

    def add_text_layer
      text_layer = Magick::Draw.new
      text_layer.font_family = font_family
      text_layer.pointsize = point_size
      text_layer.gravity = Magick::CenterGravity
      text_layer.annotate(@canvas, 0,0,0,0, text) {
        self.fill = "blue"
      }
    end

    def add_circle
      radius = @height / 3.2
      degrees_complete = (@percent_complete * 365).to_i
      circle = Magick::Draw.new
      circle.stroke(fill)
      circle.fill_opacity(0)
      circle.stroke_width(6)
      circle.stroke_linecap('round')
      circle.ellipse(canvas.rows/2,canvas.columns/2, radius, radius, 0, degrees_complete)
      circle.draw(@canvas)
    end
  end
end
