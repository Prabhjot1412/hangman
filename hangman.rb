# frozen_string_literal: false

require 'debug'
require 'colorize'
require_relative 'config.rb'
require_relative 'value.rb'
require_relative 'processor.rb'
require_relative 'helper'

conf = Config.new
lifes = conf.starting_lifes
total_score = 0

extend Helper

loop do
  value, type = Value.choose(conf)

  if value == '$WIN$'
    puts 'you win the game'
    puts_leftover(conf)
    exit
  end

  coded_value = eval("Processor.#{conf.hide_mode}(value, type)")
  system('clear')
  already_used = []

  loop do
    puts coded_value.encoded_value
    puts 'exit => quit   guess => guess'
    puts "already used => #{already_used.map {|l| coded_value.value.chars.include?(l) ? l.green : l.red}.join(', ')}"
    puts "lifes => #{lifes}"
    puts "current score => #{total_score}"
    hint = conf.hints ? ": #{lifes == 1 ? coded_value.hint : '???'}" : ""
    puts "hint -> #{already_used.size < 4 ? '???' : coded_value.type.split('_').map(&:capitalize).join(' ')} #{hint}"

    print 'enter a letter >> '
    value = gets.chomp
    system('clear')

    if already_used.include?(value)
      puts value + ' already used.'
    elsif value.size == 1
      already_used << value
      guess_correct = coded_value.reveal_letter(value)
      puts guess_correct ? 'correct guess' : 'no such letter'
      lifes -= 1 unless guess_correct

      if lifes == 0
        lose_message(coded_value, total_score)
      end

      if coded_value.solved?
        lifes += 1
        total_score += coded_value.score
        win_message(coded_value)

        break
      end
    elsif value == 'exit'
      exit
    elsif value == 'guess'
      if coded_value.value.downcase == gets.chomp
        lifes += 1
        total_score += coded_value.score
        win_message(coded_value)

        break
      else
        puts 'incorrect guess'
        lifes -= 1

        if lifes == 0
          lose_message(coded_value, total_score)
        end
      end
    elsif value == 'win' && conf.cheat_mode
      lifes += 1
      total_score += coded_value.score
      win_message(coded_value)

      break
    else
      puts 'invalid input'
    end
  end
end
