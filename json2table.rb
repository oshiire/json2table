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
  @hash = JSON.parse(params['json'])
  erb :json2table
end

# test_hash = JSON.parse(test_json)

def print_keys(hash, res = "")
  hash.each do |key, val|
    if val.is_a?(Hash) then
      # puts "#{'　' * (nest * 3)} #{key}</br>"
      # puts "<tr><td>#{key}</td></tr>\n<tr><td>\n<table>"
      res += "<tr><th>#{key}</th><th><table class=\"table is-bordered\">"
      res = print_keys(val, res)
      res += "</th></table>"
      # puts "</td></tr>\n</table>"
      # puts '</div>'
    else
      res += "<tr><td>#{key}</td><td>#{val}</td></tr>"
      # puts "#{'　' * (nest * 3)} #{key}: #{val}</br>"
      # puts "<div class=\"columns\">\n<div class=\"column\">#{key}</div>\n<div class=\"column\">#{val}</div>\n</div>"
    end
  end
  return res
end
