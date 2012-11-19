module ChefRedis
  def template_format(key, v)
    k = format_key(k)
    case v
    when TrueClass
      "#{k} on"
    when FalseClass
      "#{k} off"
    when Array
      v.map{|value| template_format(k, value) }.join("\n")
    else
      "#{k} #{v}"
    end
  end

  def format_key(k)
    k.to_s.gsub('_', '-')
  end
end
