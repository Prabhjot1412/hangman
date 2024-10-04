require 'colorize'
require_relative 'helper'
require_relative 'value'

class BargainMaker
  include Helper

  BOONS = {
    more_lifes: "some more lifes",
    increase_revealed_letters: "amount of letters visible is increased",
    random_letter_always_revealed: "a random letter will always be revealed",
    increase_life_gain: "amount of lifes gained after a successful guess is increased",
    progress: "remove random puzzles from game",
    life_gain_on_right_guess: "add chance to gain life on right guess",
    lower_pay_cost: "lower cost of life to skip",
    skip_movie_on_correct_guess: 'chance to remove a random puzzle on right guess'
  }

  PRICES = {
    fog: 'no revealed letters for next few turns',
    reduce_revealed_letters: "amount of letters visible in the begining is reduced.",
    less_lifes: "life is reduced, may result in game over",
    decrease_life_gain: 'amount of lifes gained after a successful guess is decreased',
    loose_extra_life: 'add upto 25% of extra chance to loose half of total lifes on wrong guess instead',
    no_hints: 'you can no longer see hints of any kind',
    higher_pay_cost: 'increase cost of life to skip',
    bargain_cost: 'increase cost of making bargains'
  }

  attr_accessor :config
  def initialize(config:)
    @config = config
    @boons = BOONS
    @prices = PRICES

    if config.hide_mode == 'only_vowels'
      @boons.delete(:increase_revealed_letters)
      @prices.delete(:reduce_revealed_letters)
    end
  end

  def make_offer(config:)
    boons = @boons.keys.sample(config.boons_to_choose_from > @boons.count ? @boons.count : config.boons_to_choose_from)
    price = @prices.keys.sample

    last_choice_index = boons.count() +1

    puts "How about a bargain?"
    puts "Pick a boon :-"

    boons.each_with_index do |boon, index|
      puts "#{index + 1} - #{@boons[boon]}"
    end

    puts "#{last_choice_index} skip"
    puts "If you pick a boon, a random pricee will be applied"
    puts "current price for making bargains: #{config.bargain_cost > 0 ? "#{config.bargain_cost}".red : config.bargain_cost} lifes"

    answer = get_and_validate_input(prompt: "your choice, between 1 to #{last_choice_index} >>>", possible_answers: (1..last_choice_index).to_a)

    if answer.to_i == last_choice_index
      puts "offer rejected"

      3.times do
        print '.'
        sleep 0.25
      end
    else
      if config.lifes <= config.bargain_cost
        puts "life is too low to make the bargain".blue
        sleep 0.4
        return
      end

      config.lifes -= config.bargain_cost

      grant_boon(boons[answer.to_i() -1])
      collect_price(price)

      puts "offer accepted"

      3.times do
        print '.'
        sleep 0.5
      end
    end
  end

  def grant_boon(boon)
    case boon
    when :more_lifes
      extra_lifes = 5 + rand(10)
      config.lifes += extra_lifes
      puts "lifes++ #{extra_lifes}".green
    when :increase_revealed_letters
      config.random_letters_revealed += 1
      puts "revealed letters++ 1".green
    when :random_letter_always_revealed
      letters = ('a'..'z').to_a

      if config.revealed_letters.sort == letters
        puts "No effect (all letters are already revealed) ".grey
      else
        revealable_letters = letters - config.revealed_letters
        selected_letter = revealable_letters.sample
        config.revealed_letters << selected_letter
        puts "letter '#{selected_letter}' will be always revealed"
      end
    when :increase_life_gain
      config.life_gain += 1
      puts "life gain++ #{config.life_gain}".green
    when :progress
      (rand(5) +15).times do
        Value.choose(config, skip: true)
        sleep 0.3
      end
    when :life_gain_on_right_guess
      config.gain_life_on_right_guess += 10
      puts "Chance to gain a life on right guess++ #{config.gain_life_on_right_guess}".green
    when :lower_pay_cost
      config.pay_cost -= 1
      puts "cost to skip decreased to #{config.pay_cost}".green
    when :skip_movie_on_correct_guess
      config.skip_puzzle_on_solve[:chance] = 25
      config.skip_puzzle_on_solve[:stack] += 1
      puts "added chance to remove random puzzle on right guess".green
    end
  end

  def collect_price(price)
    puts @prices[price]

    case price
    when :reduce_revealed_letters
      config.random_letters_revealed -= 1
      puts "revealed letters reduced to #{config.random_letters_revealed}".red
    when :less_lifes
      less_lifes = 5 + rand(10)
      config.lifes -= less_lifes
      puts "lifes-- #{less_lifes}".red
    when :fog
      config.fog += 3 + rand(7)
      puts "letters won't be revealed for few turns".red
    when :decrease_life_gain
      config.life_gain -= 1
      puts "life gain-- #{config.life_gain}".red
    when :loose_extra_life
      config.loose_half_life_on_wrong_guess += ( 5 + rand(15) )
      puts "Chance to loose half life on wrong guess++ #{config.loose_half_life_on_wrong_guess}".red
    when :no_hints
      config.hints_disabled = true
      @prices.delete(:no_hints)
      puts "All hints are disabled".red
    when :higher_pay_cost
      config.pay_cost += 1 + rand(2)
      puts "cost to skip increased to #{config.pay_cost}".red
    when :bargain_cost
      config.bargain_cost += 1
      puts "bargain cost increased to #{config.bargain_cost}".red
    end
  end
end
