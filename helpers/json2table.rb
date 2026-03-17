# frozen_string_literal: true

require "rack/utils"

def h(text)
  Rack::Utils.escape_html(text.to_s)
end

def print_keys(hash, res = "")
  hash.each do |key, val|
    if val.is_a?(Hash) || val.is_a?(Array)
      res += "<tr><td>#{h(key)}</td><td><table class=\"table is-bordered\">"
      res = print_keys(val, res)
      res += "</table></td></tr>"
    elsif key.is_a?(Hash) && val.nil?
      res += "<tr><td><table class=\"table is-bordered\">"
      res = print_keys(key, res)
      res += "</table></td></tr>"
    elsif val.nil?
      res += "<tr><td>#{h(key)}</td></tr>"
    else
      res += "<tr><td>#{h(key)}</td><td>#{h(val)}</td></tr>"
    end
  end

  res
end
