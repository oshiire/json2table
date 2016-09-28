#!/usr/bin/env ruby
# coding: utf-8

require 'json'

# JSON テストデータ
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

test_hash = JSON.parse(test_json)

def print_keys(hash, nest = 0)
  hash.each do |key, val|
    if val.is_a?(Hash) then
      # puts "#{'　' * (nest * 3)} #{key}</br>"
      # puts "<tr><td>#{key}</td></tr>\n<tr><td>\n<table>"
      puts "<tr><th>#{key}</th><th><table class=\"table is-bordered\">"
      print_keys(val, nest + 1)
      puts "</th></table>"
      # puts "</td></tr>\n</table>"
      # puts '</div>'
    else
      puts "<tr><td>#{key}</td><td>#{val}</td></tr>"
      # puts "#{'　' * (nest * 3)} #{key}: #{val}</br>"
      # puts "<div class=\"columns\">\n<div class=\"column\">#{key}</div>\n<div class=\"column\">#{val}</div>\n</div>"
    end
  end
end

puts '<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8" />
<title>KOMATSU POC</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.1.2/css/bulma.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
</head>
<body><div class="container"><table class="table">'

print_keys(test_hash)

puts '</table></div></body></html>'
