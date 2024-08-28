require 'colorize'
require_relative 'helper'

class BargainMaker
  include Helper

  BOONS = {
    more_lifes: "some more lifes",
    increase_revealed_letters: "amount of letters visible is increased",
    random_letter_always_revealed: "a random letter will always be revealed"
  }

  PRICES = {
    reduce_revealed_letters: "amount of letters visible in the begining is reduced.",
    less_lifes: "life is reduces, may result in game over",
    fog: 'no revealed letters for next few turns',
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

  def make_offer
    boon = @boons.keys.sample
    price = @prices.keys.sample

    puts "How about a bargain?"
    puts "what you will get   :-    #{@boons[boon]}"
    puts "what you will loose :-    #{@prices[price]}"

    answer = get_and_validate_yes_no_input("your choice yes/y or no/n >>>")

    if answer == false
      puts "offer rejected"

      3.times do
        print '.'
        sleep 0.25
      end
    else
      grant_boon(boon)
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
      extra_lifes = rand(10)
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
    end
  end

  def collect_price(price)
    case price
    when :reduce_revealed_letters
      config.random_letters_revealed -= 1
      puts "revealed letters-- 1".red
    when :less_lifes
      less_lifes = 15 - rand(10)
      config.lifes -= less_lifes
      puts "lifes-- #{less_lifes}".red
    when :fog
      config.fog += rand(4) + 1
      puts "letters won't be revealed for few turns".red
    end
  end
end