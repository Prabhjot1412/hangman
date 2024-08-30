require_relative 'config.rb'
require_relative 'value.rb'
require 'colorize'

module Helper
  def lose(coded_value, total_score)
    puts "you lose, answer #{coded_value.value}"
    puts "your total score is #{total_score}"
    exit
  end

  def win(coded_value, total_score, turn, bargain_maker, config)
    puts "you won, it was: #{coded_value.value}"

    3.times do
      print '.'
      sleep 0.25
    end

    if turn % config.bargain_frequency == 0
      bargain_maker.make_offer

      lose(coded_value, total_score) if config.lifes <= 0
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

  def get_and_validate_yes_no_input(message)
    print "#{message}"
    input = gets.chomp

    while !['yes', 'y', 'no', 'n'].include?(input.downcase)
      puts 'invalid input'
      print "#{message}"
      input = gets.chomp
    end
  
    if ['yes', 'y'].include?(input.downcase)
      return true
    else
      return false
    end
  end

  def loose_life(config, coded_value, total_score)
    if check_chance(config.loose_half_life_on_wrong_guess)
      config.lifes /= 2
    else
      config.lifes -= 1
    end

    if config.lifes == 0
      lose(coded_value, total_score)
    end
  end

  def add_life(config, amt)
    config.lifes += amt
  end

  def check_chance(chance_percentage)
    return true if (rand(100) +1) <= chance_percentage

    false
  end
end
