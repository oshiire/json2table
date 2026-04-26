# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe "#print_keys" do
  describe "basic rendering" do
    it "renders a simple key-value pair" do
      html = print_keys({"name" => "Alice"})
      expect(html).to include("<tr><td>name</td><td>Alice</td></tr>")
    end

    it "renders multiple key-value pairs" do
      html = print_keys({"a" => "1", "b" => "2"})
      expect(html).to include("<td>a</td><td>1</td>")
      expect(html).to include("<td>b</td><td>2</td>")
    end

    it "renders nil values as key-only rows" do
      html = print_keys({"empty" => nil})
      expect(html).to include("<tr><td>empty</td></tr>")
    end
  end

  describe "nested structures" do
    it "renders nested hashes as nested tables" do
      html = print_keys({"user" => {"name" => "Bob"}})
      expect(html).to include("<table")
      expect(html).to include("<td>name</td><td>Bob</td>")
    end

    it "renders arrays as nested tables" do
      html = print_keys({"items" => [{"id" => 1}, {"id" => 2}]})
      expect(html).to include("<table")
      expect(html).to include("<td>id</td><td>1</td>")
      expect(html).to include("<td>id</td><td>2</td>")
    end

    it "renders hash-as-key with nil value as nested table" do
      hash = {}
      hash.compare_by_identity
      # Simulate the Array#each yielding [element, nil] pattern
      input = [{"nested" => "val"}]
      html = print_keys(input)
      expect(html).to include("<table")
      expect(html).to include("<td>nested</td><td>val</td>")
    end

    it "renders array-as-key with nil value as nested table" do
      # Top-level Array#each yields each element. Destructured as |key, val|,
      # an inner array of length 1 where the element is itself an Array makes
      # key = [...], val = nil — the M3 case the original branch missed.
      input = [[[1, 2]], [[3, 4]]]
      html = print_keys(input)
      expect(html).to include("<table")
      expect(html).to include("<td>1</td>")
      expect(html).to include("<td>2</td>")
      expect(html).to include("<td>3</td>")
      expect(html).to include("<td>4</td>")
      # Pre-fix this rendered the array's to_s like "[1, 2]" inside a single <td>.
      expect(html).not_to match(/<td>\[\d/)
    end
  end

  describe "performance" do
    it "renders 20000 flat keys in well under a second (linear-time guard)" do
      require "benchmark"
      hash = (1..20_000).to_h { |i| ["k#{i}", "v#{i}"] }
      elapsed = Benchmark.realtime { print_keys(hash) }
      expect(elapsed).to be < 0.5
    end
  end

  describe "XSS prevention" do
    it "escapes HTML in keys" do
      html = print_keys({"<script>alert(1)</script>" => "safe"})
      expect(html).not_to include("<script>")
      expect(html).to include("&lt;script&gt;")
    end

    it "escapes HTML in values" do
      html = print_keys({"key" => "<img onerror=alert(1)>"})
      expect(html).not_to include("<img onerror")
      expect(html).to include("&lt;img onerror")
    end

    it "escapes HTML in nested hash keys" do
      html = print_keys({"parent" => {"<b>bold</b>" => "val"}})
      expect(html).not_to include("<b>bold</b>")
      expect(html).to include("&lt;b&gt;")
    end

    it "escapes HTML in nested hash values" do
      html = print_keys({"parent" => {"key" => "<script>xss</script>"}})
      expect(html).not_to include("<script>xss</script>")
      expect(html).to include("&lt;script&gt;")
    end

    it "escapes HTML in nil-value keys" do
      html = print_keys({"<div onclick=hack>" => nil})
      expect(html).not_to include("<div onclick")
      expect(html).to include("&lt;div onclick")
    end
  end
end
