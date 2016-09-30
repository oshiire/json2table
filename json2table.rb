#!/usr/bin/env ruby
# coding: utf-8

require "sinatra"
require "json"

VERSION = "0.22"

get '/' do
  erb :index
end

post '/' do
  @hash = JSON.parse(params['json'], quirks_mode: true)
  erb :json2table
end

def print_keys(hash, res = "")

  hash.each do |key, val|
    if val.is_a?(Hash)
      res += "<tr><td>#{key}</td><td><table class=\"table is-bordered\">"
      res = print_keys(val, res)
      res += "</table></td></tr>"
    elsif val.is_a?(Array)
      res += "<tr><td rowspan=\"#{val.count+1}\">#{key}</td>"
      res = print_keys(val, res)
      res += "</tr>"
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
