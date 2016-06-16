module GifTimer
  class Gif
    attr_reader :time_difference
    FRAME_COUNT = 60
    FRAME_DELAY = 100
    GIF_FOLDER = "./gifs"

    def initialize(time_difference)
      @time_difference = time_difference
    end

    def self.find_or_create(time_difference)
      frame = new(time_difference)
      frame.save unless frame.exist?
      frame
    end

    def save
      frame_paths = frames.map(&:path)
      ImageMagick.create_gif(frames: frame_paths, delay: FRAME_DELAY, output_path: path)
    end

    def path
      "#{GIF_FOLDER}/#{time_difference}.gif"
    end

    def exist?
      File.exist?(path)
    end

    private

    def frames
      @frames ||= frame_durations.map { |frame_time_difference| Frame.find_or_create(frame_time_difference) }
    end

    def frame_durations
      (time_difference..(time_difference + FRAME_COUNT)).to_a.reverse
    end
  end
end