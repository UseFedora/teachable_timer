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
  time_difference = end_time - start_time
  if start_time > end_time
    # handle finished timer case
  else

    output_path = create_gif(time_difference: time_difference)
    send_file(output_path, filename: "timer.gif", type: 'image/gif', disposition: :inline)
  end
end

