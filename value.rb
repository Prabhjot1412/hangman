require_relative 'config'

module Value
  @already_used = {}

  def self.choose(conf, skip: false)
    count = 0

    loop do
      categories = conf.categories

      type = categories
                  .select {|_k, v| v[0]}
                  .keys
                  .sample

      value = eval(categories[type][1])

      @already_used[type] ||= []
      unless @already_used[type].include?(value)
        @already_used[type] << value
        puts "\n #{value.split(';')[0]}".blue if skip 
        return [value.downcase, type.to_s]
      end

      if count >= 10
        return ['$WIN$', "$WIN$"]
      end

      count += 1
      unless skip
        puts "\n#{count} #{value.split(';')[0]}" 
        sleep 1
      end
    end
  end

  def self.already_used
    @already_used
  end
end
