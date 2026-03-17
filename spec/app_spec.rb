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

  describe "GET /handson" do
    it "returns 200" do
      get "/handson"
      expect(last_response).to be_ok
    end
  end
end
