# timer_api

#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require_relative 'generate_gif'

$pwd = ENV['PWD']

get '/api/timer.gif' do
  timestamp = request.env["rack.request.query_hash"]["end_time"]
  # generate file for timestamp and store local dir
  start_time = Time.now.to_i
  end_time = timestamp.to_i
  if start_time > end_time
    # handle finished timer case
  else

    output_path = "./tmp/#{start_time}-#{end_time}.gif"
    create_gif(start_time: start_time, end_time: end_time, output_path: output_path)
    send_file(output_path, filename: output_path, type: 'image/gif', disposition: :inline)
  end
end

