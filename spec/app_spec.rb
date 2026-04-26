# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe "JSON to Table App" do
  describe "GET /" do
    it "returns 200" do
      get "/"
      expect(last_response).to be_ok
    end

    it "contains the input form" do
      get "/"
      expect(last_response.body).to include('<textarea name="json"')
    end
  end

  describe "POST / with valid JSON" do
    it "returns 200 and renders a table" do
      post "/", json: '{"name": "test"}'
      expect(last_response).to be_ok
      expect(last_response.body).to include("<table")
      expect(last_response.body).to include("name")
    end
  end

  describe "POST / with invalid JSON" do
    it "returns 200 with error message" do
      post "/", json: "not valid json"
      expect(last_response).to be_ok
      expect(last_response.body).to include("Error")
    end
  end

  describe "POST / with empty or missing input" do
    it "returns 200 with error message for empty json field" do
      post "/", json: ""
      expect(last_response).to be_ok
      expect(last_response.body).to include("Error")
    end

    it "returns 200 with error message when json field is missing" do
      post "/"
      expect(last_response).to be_ok
      expect(last_response.body).to include("Error")
    end
  end

  describe "POST / size and nesting limits" do
    it "rejects payloads larger than MAX_JSON_BYTES with 413" do
      oversize = '"' + ("a" * (MAX_JSON_BYTES + 10)) + '"'
      post "/", json: oversize
      expect(last_response.status).to eq(413)
    end

    it "accepts payloads just under the size limit" do
      # Object-shaped JSON whose total size sits just under the cap.
      value = "a" * (MAX_JSON_BYTES - 100)
      payload = %Q({"k":"#{value}"})
      post "/", json: payload
      expect(last_response.status).to eq(200)
    end

    it "rejects deeply nested JSON via parser nesting limit" do
      deep = ("[" * 100) + ("]" * 100)
      post "/", json: deep
      expect(last_response).to be_ok
      expect(last_response.body).to include("Error")
    end
  end

  describe "XSS prevention in POST /" do
    it "escapes script tags in JSON values" do
      post "/", json: '{"key": "<script>alert(1)</script>"}'
      expect(last_response.body).not_to include("<script>alert(1)</script>")
    end

    it "escapes script tags in JSON keys" do
      post "/", json: '{"<script>alert(1)</script>": "val"}'
      expect(last_response.body).not_to include("<script>alert(1)</script>")
    end

    it "escapes script tags in the original hash display" do
      post "/", json: '{"<img onerror=alert(1)>": "xss"}'
      body = last_response.body
      # The footer shows original hash — must be escaped
      expect(body).not_to match(/<img[^>]*onerror/)
    end

    it "escapes script tags in parse error messages" do
      post "/", json: "<script>alert(1)</script>"
      expect(last_response.body).not_to include("<script>alert(1)</script>")
    end
  end

  describe "layout assets" do
    it "loads Bulma CDN with subresource integrity" do
      get "/"
      expect(last_response.body).to include('integrity="sha256-')
      expect(last_response.body).to include('crossorigin="anonymous"')
    end
  end

  describe "Content-Security-Policy header" do
    it "sets default-src to 'self' on GET /" do
      get "/"
      csp = last_response.headers["Content-Security-Policy"]
      expect(csp).to include("default-src 'self'")
    end

    it "allows the Bulma CDN host in style-src" do
      get "/"
      csp = last_response.headers["Content-Security-Policy"]
      expect(csp).to include("cdn.jsdelivr.net")
    end

    it "sets the same CSP on POST /" do
      post "/", json: '{"a":1}'
      csp = last_response.headers["Content-Security-Policy"]
      expect(csp).to include("default-src 'self'")
    end
  end

  describe "GET /handson" do
    it "is removed and returns 404" do
      get "/handson"
      expect(last_response.status).to eq(404)
    end
  end
end
