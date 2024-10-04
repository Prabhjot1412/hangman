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

    if check_chance(config.skip_puzzle_on_solve[:chance])
      config.skip_puzzle_on_solve[:stack].times do
        Value.choose(config, skip: true)
        sleep 0.5
      end
    end

    if turn % config.bargain_frequency == 0
      bargain_maker.make_offer(config: config)

      lose(coded_value, total_score) if config.lifes <= 0
    end
  end

  def puts_leftover(conf, pg, total_score)
    VALUE_COLLECTION.keys.each do |key|
      puts "#{key.to_s.humanize}s left: #{VALUE_COLLECTION[key].first(conf.difficulty).select {|item| !Value.already_used[key].include?(item)}.count}"
    end
    puts ''
    puts 'add your score and exit: add              view previous winners: list' if pg

    added = false
    loop do
      user_inp = gets.chomp
      exit if user_inp == 'exit'

      key = user_inp.to_sym

      if VALUE_COLLECTION.keys.include?(key)
        VALUE_COLLECTION[key].first(conf.difficulty).each do |item|
          eval("puts item.split(';')[0].#{Value.already_used[key].include?(item) ? 'green' : 'red'}")
        end
      elsif user_inp == 'add' && pg && !added
        print "enter name: "
        name = gets.chomp
        pg.create_winner(name, total_score)
        added = true
        puts "added score successfully".green
      elsif user_inp == 'add' && added
        puts "already added".red
      elsif user_inp == 'list' && pg
        winners = pg.winners(limit: 30)
        winners.each do |winner|
          puts "#{winner.name}   #{winner.score}"
        end
      else
        puts 'invalid input'
      end

    end
  end

  def get_and_validate_input(prompt:, possible_answers:)
    print "#{prompt}"
    input = gets.chomp
    
    while !possible_answers.map(&:to_s).include?(input.to_s)
      puts 'invalid input'
      print "#{prompt}"
      input = gets.chomp
    end

    return input
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

  def hint(already_used:, config:, hint:, coded_value:)
    return "" if config.hints_disabled

    "hint -> #{already_used.size < config.random_letters_revealed + config.hint_after_this_many_attempts ? '???' : coded_value.type.split('_').map(&:capitalize).join(' ')} #{hint}"
  end
end
