#!/usr/bin/env ruby
# coding: utf-8

require "sinatra"
require "json"

# JSON テストデータ
=begin
test_json = '{"widget": {
"debug": "on",
"window": {
"title": "Sample Konfabulator Widget",
"name": "main_window",
"width": 500,
"height": 500
},
"image": {
"src": "Images/Sun.png",
"name": "sun1",
"hOffset": 250,
"vOffset": 250,
"alignment": "center"
},
"text": {
"data": "Click Here",
"size": 36,
"style": "bold",
"name": "text1",
"hOffset": 250,
"vOffset": 100,
"alignment": "center",
"onMouseUp": "sun1.opacity = (sun1.opacity / 100) * 90;"
}
}}'
=end

get '/' do
  erb :index
end

post '/' do
  # json  = JSON.dump(params['json'])
  @hash = JSON.parse(params['json'], quirks_mode: true)
  erb :json2table
end

# test_hash = JSON.parse(test_json)

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
