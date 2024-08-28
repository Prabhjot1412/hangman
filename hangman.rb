# frozen_string_literal: false

require 'debug'
require 'colorize'
require_relative 'config.rb'
require_relative 'value.rb'
require_relative 'processor.rb'
require_relative 'helper'
require_relative 'bargain_maker'

conf = Config.new
total_score = 0
turn = 0

extend Helper

loop do
  value, type = Value.choose(conf)

  if value == '$WIN$'
    puts 'you win the game'
    puts_leftover(conf)
  end

  coded_value = eval("Processor.#{conf.hide_mode}(value, type, conf)")
  system('clear')
  already_used = coded_value.revealed_letters
  bargain_maker = BargainMaker.new(config: conf)

  loop do
    puts coded_value.encoded_value
    puts 'exit => quit'
    puts "already used => #{already_used.map {|l| coded_value.value.chars.include?(l) ? l.green : l.red}.join(', ')}"
    puts "lifes => #{conf.lifes}"
    puts "current score => #{total_score}"
    hint = conf.hints ? ": #{conf.lifes <= 2 ? coded_value.hint : '???'}" : ""
    puts "hint -> #{already_used.size < conf.random_letters_revealed + 2 ? '???' : coded_value.type.split('_').map(&:capitalize).join(' ')} #{hint}"

    print 'enter a letter >> '
    value = gets.chomp
    system('clear')

    if already_used.include?(value)
      puts value + ' already used.'
    elsif value.size == 1
      guess_correct = coded_value.reveal_letter(value)
      puts guess_correct ? 'correct guess' : 'no such letter'
      conf.lifes -= 1 unless guess_correct

      if conf.lifes == 0
        lose(coded_value, total_score)
      end

      if coded_value.solved?
        conf.lifes += 1
        total_score += coded_value.score
        turn += 1
        win(coded_value, total_score, turn, bargain_maker, conf)

        break
      end
    elsif value == 'exit'
      exit
    elsif value == 'win' && conf.cheat_mode
      conf.lifes += 1
      total_score += coded_value.score
      turn += 1
      win(coded_value, total_score, turn, bargain_maker, conf)

      break
    else
      puts 'invalid input'
    end
  end
end
