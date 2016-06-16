require './timer_api'
require "fileutils"

FileUtils.mkdir_p(GifTimer::Frame::FRAME_FOLDER)
run Sinatra::Application
