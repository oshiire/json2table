#!/usr/bin/env ruby
# coding: utf-8

require "sinatra"
require "json"
require "./helpers/json2table.rb"

VERSION = (File::stat(__FILE__).mtime.to_i/60).to_s

configure do
  set :protection, :except => :frame_options
end

get '/' do
  erb :index
end

post '/' do
  begin
    @hash = JSON.parse(params['json'], quirks_mode: true)
    erb :json2table
  rescue JSON::ParserError => e
    @error = e
    erb :index
  end
end

get '/handson' do
  erb :handson
end
