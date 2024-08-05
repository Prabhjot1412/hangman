require_relative 'config.rb'
require_relative 'value.rb'

module Helper
  def lose_message(coded_value, total_score)
    puts "you lose, answer #{coded_value.value}"
    puts "your total score is #{total_score}"
    exit
  end

  def win_message(coded_value)
    puts "you won, it was: #{coded_value.value}"

    3.times do
      print '.'
      sleep 0.25
    end
  end

  def puts_leftover(conf)
    VALUE_COLLECTION.keys.each do |key|
      puts "#{key.to_s.humanize}s left: #{VALUE_COLLECTION[key].first(conf.difficulty).select {|item| !Value.already_used[key].include?(item)}.count}"
    end
  end
end
