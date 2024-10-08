module Processor
  Vowels = ['a', 'e', 'i', 'o', 'u']

  class Code
    require_relative 'config.rb'

    attr_reader :chars, :type, :hint, :revealed_letters
    def initialize(chars, type, hint, revealed_letters: [])
      @chars = chars
      @type = type
      @hint = hint
      @revealed_letters = revealed_letters
    end

    def value
      @chars.map {|v| v[0]}.join
    end

    def encoded_value
      @chars.map {|v| v[1] ? '_' : v[0]}.join
    end

    def reveal_letter(l)
      is_changed = false

      @chars.each_with_index do |v, i|
        if l == v[0]
          @chars[i][1] = false
          is_changed = true
        end
      end

      @revealed_letters << l unless @revealed_letters.include?(l)
      return is_changed
    end

    def guess(g)
      return true if value == g.downcase

      return false
    end

    def solved?
      chars.none? {|v| v[1]}
    end

    def score
      @chars.reduce(0) do |collector, char|
        collector += char[0] >= 'a' && char[0] <= 'z' ?
                      Config.score[char[0].to_sym] : 0
      end
    end
  end

  def self.only_vowels(value, type, conf)
    if conf.fog > 0
      conf.fog -= 1
      return fully_hidden(value, type, conf)
    end

    new_value, hint = split_value_and_hint(value)
    chars = new_value.split('')

    chars.map! do |v|
      hidden = is_hidden?(v) ? true : false
      [v, hidden]
    end

    Code.new(chars, type, hint, revealed_letters: (Vowels + conf.revealed_letters.clone).uniq)
  end

  def self.fully_hidden(value, type, conf)
    new_value, hint = split_value_and_hint(value)
    chars = new_value.split('')

    chars.map! do |v|
      if conf.fog > 0 && conf.revealed_letters.include?(v)
        [v, false]
      else
        hidden = is_hidden?(v, :fully_hidden) ? true : false
        [v, hidden]
      end
    end

    Code.new(chars, type, hint, revealed_letters: conf.revealed_letters.clone)
  end

  def self.random_revealed(value, type, conf)
    if conf.fog > 0
      coded_value = fully_hidden(value, type, conf)
      conf.fog -= 1
      return coded_value
    end

    new_value, hint = split_value_and_hint(value)
    chars = new_value.split('')
    revealed_letters = ('a'..'z').to_a.sample(conf.random_letters_revealed > 0 ? conf.random_letters_revealed : 0) + conf.revealed_letters
    revealed_letters.uniq!

    chars.map! do |v|
      unless is_hidden?(v, :fully_hidden)
        [v, false]
      else
        unless revealed_letters.include?(v.downcase)
          [v, true]
        else
          [v,false]
        end
      end
    end

    Code.new(chars, type, hint, revealed_letters: revealed_letters)
  end

  private

  def self.is_hidden?(v, type = :only_vowels)
    return false if v == ' '
    return false if type == :only_vowels && Vowels.include?(v) 
    return false unless v >= 'a' && v <= 'z' # if its not an alphabet

    return true
  end

  def self.split_value_and_hint(value)
    value_and_hint = value.split(';')
    return [value, 'no hint available'] if value_and_hint.length == 1

    return value_and_hint
  end
end