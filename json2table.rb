#!/usr/bin/env ruby
# coding: utf-8

require "sinatra"
require "json"

VERSION = "0.30"

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

def print_keys(hash, res = "")

  hash.each do |key, val|
    if val.is_a?(Hash) || val.is_a?(Array)
      res += "<tr><td>#{key}</td><td><table class=\"table is-bordered\">"
      res = print_keys(val, res)
      res += "</table></td></tr>"
=begin
    elsif val.is_a?(Array)
      res += "<tr><td rowspan=\"#{val.count+1}\">#{key}</td>"
      res = print_keys(val, res)
      res += "</tr>"
=end
    elsif key.is_a?(Hash) && val.nil?
      res += "<tr><td><table class=\"table is-bordered\">"
      res = print_keys(key, res)
      res += "</table></td></tr>"
    elsif val.nil?
      res += "<tr><td>#{key}</td></tr>"
    else
      res += "<tr><td>#{key}</td><td>#{val}</td></tr>"
    end
  end

  return res
end
