module ChefRedis
  class << self
    def template_format(key, v)
      k = format_key(key)
      case v
      when TrueClass
        "#{k} yes"
      when FalseClass
        "#{k} no"
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
end
