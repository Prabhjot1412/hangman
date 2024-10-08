# frozen_string_literal: false

require 'debug'
require 'colorize'
require_relative 'config.rb'
require_relative 'value.rb'
require_relative 'processor.rb'
require_relative 'helper'
require_relative 'bargain_maker'
require_relative 'pg_helper'

conf = Config.new
pg  = PgHelper.create_connection
total_score = 0
turn = 0

extend Helper

loop do
  value, type = Value.choose(conf)

  if value == '$WIN$'
    puts 'you win the game'
    puts_leftover(conf, pg, total_score)
  end

  coded_value = eval("Processor.#{conf.hide_mode}(value, type, conf)")
  system('clear')
  already_used = coded_value.revealed_letters
  bargain_maker = BargainMaker.new(config: conf)

  loop do
    if coded_value.solved? # may happen if all the letters are already revealed.
      add_life(conf, conf.life_gain)
      total_score += coded_value.score
      turn += 1
      win(coded_value, total_score, turn, bargain_maker, conf)

      break
    end

    puts coded_value.encoded_value
    puts "exit => quit pay => pay #{conf.pay_cost} lifes to skip"
    puts "already used => #{already_used.map {|l| coded_value.value.chars.include?(l) ? l.green : l.red}.join(', ')}"
    puts "lifes => #{conf.lifes}"
    puts "current score => #{total_score}"
    hint = conf.hints ? ": #{conf.lifes <= conf.hint_life_threshold ? coded_value.hint : '???'}" : ""
    puts hint(already_used:, config: conf, coded_value:, hint:)

    print 'enter a letter >> '
    value = gets.chomp
    system('clear')

    if already_used.include?(value)
      puts value + ' already used.'
    elsif value.size == 1
      guess_correct = coded_value.reveal_letter(value)
      puts guess_correct ? 'correct guess' : 'no such letter'
      add_life(conf, 1) if guess_correct && check_chance(conf.gain_life_on_right_guess)
      loose_life(conf, coded_value, total_score) unless guess_correct

      if coded_value.solved?
        add_life(conf, conf.life_gain)
        total_score += coded_value.score
        turn += 1
        win(coded_value, total_score, turn, bargain_maker, conf)

        break
      end
    elsif value == 'pay'
      conf.lifes -= conf.pay_cost

      if conf.lifes <= 0
        lose(coded_value, total_score)
      else
        total_score += coded_value.score
        turn += 1
        win(coded_value, total_score, turn, bargain_maker, conf)

        break
      end
    elsif value == 'exit'
      exit
    elsif value == 'win' && conf.cheat_mode
      add_life(conf, conf.life_gain)
      total_score += coded_value.score
      turn += 1
      win(coded_value, total_score, turn, bargain_maker, conf)

      break
    elsif value == 'debug' && conf.debug_mode
      debugger
    else
      puts 'invalid input'
    end
  end
end
