require_relative 'config.rb'
require_relative 'value.rb'
require 'colorize'

module Helper
  def lose(coded_value, total_score)
    puts "you lose, answer #{coded_value.value}"
    puts "your total score is #{total_score}"
    exit
  end

  def win(coded_value)
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

    loop do
      user_inp = gets.chomp
      exit if user_inp == 'exit'

      key = user_inp.to_sym

      if VALUE_COLLECTION.keys.include?(key)
        VALUE_COLLECTION[key].first(conf.difficulty).each do |item|
          eval("puts item.split(';')[0].#{Value.already_used[key].include?(item) ? 'green' : 'red'}")
        end
      else
        puts 'invalid input'
      end
    end
  end
end
