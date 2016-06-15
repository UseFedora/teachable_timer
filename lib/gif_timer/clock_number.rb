require "rmagick"

module GifTimer

  class ClockNumber

    attr_reader :canvas, :width, :height, :font_family, :fill, :point_size, :text

    def initialize(
                   width: 800,
                   height: 800,
                   number: 12,
                   max: 60,
                   font_family: "helvetica",
                   point_size: 192,
                   caption_point_size: 84,
                   caption_text: "MINUTES",
                   fill: "black"
                   )
      @width = width
      @height = height
      @number = number
      @max = max
      percentage = @number.to_f/@max
      @percent_complete = percentage.nan? ? 1.0 : percentage
      #@percent_complete = percentage.nan? ? 1.0 : 1.0 # for 0 circle
      @text = pad_number(number: @number)
      @font_family = font_family
      @point_size = point_size
      @caption_point_size = caption_point_size
      @caption_text = caption_text.upcase
      @fill = fill
      @canvas = Magick::ImageList.new
      @canvas.new_image(@width, @height)
    end

    def pad_number(number: 0)
      (number < 10) ? "0#{number}" : number.to_s
    end

    def self.generate(number:, folder:, caption_text:)
      image = new(number: number)
      image.generate_image(folder: folder)
    end

    def generate_image(folder:)
      add_time_remaining_text
      add_caption_text
      add_circle if @number > 0
      @canvas.scale!(0.5)
      @canvas = @canvas.optimize_layers(Magick::OptimizeLayer)
      @canvas.write("#{folder}/#{@number}.gif")
    end

    def add_time_remaining_text
      text_layer = Magick::Draw.new
      text_layer.font_family = font_family
      text_layer.pointsize = point_size
      text_layer.gravity = Magick::CenterGravity
      text_layer.fill = @fill
      text_layer.annotate(@canvas, 0,0,0,0, text)
    end

    def add_caption_text
      text_layer = Magick::Draw.new
      text_layer.font_family = font_family
      text_layer.pointsize = @caption_point_size
      text_layer.gravity = Magick::CenterGravity
      text_layer.fill = @fill
      text_layer.annotate(@canvas, 0,0,0,324, @caption_text)
    end

    def add_circle
      radius = @height / 3.2
      degrees_complete = (@percent_complete * 360).to_i
      circle = Magick::Draw.new
      circle.stroke(@fill)
      circle.fill_opacity(0)
      circle.stroke_width(6)
      circle.stroke_linecap('round')
      circle.ellipse(canvas.rows/2,canvas.columns/2, radius, radius, 0, degrees_complete)
      circle.draw(@canvas)
    end
  end

end