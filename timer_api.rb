# timer_api

#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require_relative 'generate_gif'

$pwd = ENV['PWD']

get '/api/timer/end_time=:timestamp' do |filename|
  # generate file for timestamp and store local dir
  # filename = combine_images(timestamp)
  timestamp = params[:timestamp]
  puts timestamp
  filename = "hours/23.gif"
  send_file("./tmp/frames/#{filename}", filename: filename, type: 'image/gif', disposition: :inline)
end