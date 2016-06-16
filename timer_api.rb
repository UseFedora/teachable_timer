# timer_api

#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require_relative 'lib/gif_timer'

$pwd = ENV['PWD']

get '/api/timer.gif' do
  end_time_ms_since_epoch = request.env["rack.request.query_hash"]["end_time"].to_i
  # generate file for timestamp and store local dir
  start_time = Time.now.to_i
  end_time = end_time_ms_since_epoch / 1000
  time_difference =  end_time - start_time
  if start_time > end_time
    time_difference = 0
    # handle finished timer case
  end
  # round to nearest minute for caching
  rounded_time_difference = ((time_difference/60) * 60)
  gif = GifTimer::Gif.find_or_create(rounded_time_difference)

  send_file(gif.path, filename: "timer.gif", type: 'image/gif', disposition: :inline)
end

