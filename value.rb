module Value
  def self.choose(conf)
    categories = conf.categories
    type = categories
                .select {|_k, v| v[0]}
                .keys
                .sample

    value = eval(categories[type][1])
    return [value.downcase, type.to_s]
  end
end
