#!/usr/bin/env ruby
# frozen_string_literal: true

require "sinatra"
require "rack/protection"
require "json"
require_relative "helpers/json2table"

VERSION = ENV.fetch("HEROKU_SLUG_COMMIT") { (File::stat(__FILE__).mtime.to_i / 60).to_s }[0, 8]

MAX_JSON_BYTES = 256 * 1024
MAX_JSON_NESTING = 32

configure do
  set :protection, :except => :frame_options
end

use Rack::Protection::ContentSecurityPolicy,
    default_src: "'self'",
    style_src: "'self' https://cdn.jsdelivr.net",
    img_src: "'self' data:",
    script_src: "'none'",
    base_uri: "'none'",
    form_action: "'self'",
    frame_ancestors: "'none'"

get '/' do
  erb :index
end

post '/' do
  input = params['json'].to_s
  if input.empty?
    @error = "Empty input"
    return erb(:index)
  end

  halt 413, "Payload too large" if input.bytesize > MAX_JSON_BYTES

  begin
    @hash = JSON.parse(input, quirks_mode: true, max_nesting: MAX_JSON_NESTING)
    erb :json2table
  rescue JSON::ParserError => e
    @error = e
    erb :index
  end
end

