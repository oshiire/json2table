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
