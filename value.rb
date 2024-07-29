require_relative 'config'

module Value
  @already_used = []

  def self.choose(conf)
    count = 0

    loop do
      categories = conf.categories

      type = categories
                  .select {|_k, v| v[0]}
                  .keys
                  .sample

      value = eval(categories[type][1])

      unless @already_used.include?(value)
        @already_used << value
        return [value.downcase, type.to_s]
      end

      if count >= 10
        return ['$WIN$', "$WIN$"]
      end

      count += 1
      puts "\n#{count} #{value.split(';')[0]}"
      sleep 1
    end
  end
end
