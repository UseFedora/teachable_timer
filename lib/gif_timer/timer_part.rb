require "pry"
module GifTimer

  # Class TimerPart is used for generating each part of the time (days/hours/minutes/seconds)
  class TimerPart

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
                   fill: "gray",
                   force_circle: false,
                   folder:
                   )
      @width = width
      @height = height
      @number = number
      @max = max
      @force_circle = force_circle
      @text = pad_number(number: @number)
      @font_family = font_family
      @point_size = point_size
      @caption_point_size = caption_point_size
      @caption_text = caption_text.upcase
      @fill = fill
      @folder = folder
      @canvas = Magick::ImageList.new
      @canvas.new_image(@width, @height)
    end

    def save
      add_time_remaining_text
      add_caption_text
      add_circle
      @canvas.scale!(0.25)
      @canvas.write("#{@folder}/#{@number}.png")
    end

    private

    def pad_number(number: 0)
      (number < 10) ? "0#{number}" : number.to_s
    end

    def add_time_remaining_text
      text_layer = Magick::Draw.new
      text_layer.font_family = font_family
      text_layer.pointsize = point_size
      text_layer.text_antialias = true
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
      circle = Magick::Draw.new
      circle.stroke(@fill)
      circle.fill_opacity(0)
      circle.stroke_width(6)
      circle.stroke_linecap('round')
      circle.ellipse(canvas.rows/2,canvas.columns/2, radius, radius, 0, degrees_complete)
      circle.draw(@canvas)
    end

    def percent_complete
      @number.to_f / @max
    end

    def degrees_complete
      return 360 if @force_circle || (@number == 0)
      (percent_complete * 360).to_i
    end
  end
end