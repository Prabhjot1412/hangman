module Processor
  Vowels = ['a', 'e', 'i', 'o', 'u']

  class Code
    require_relative 'config.rb'

    attr_reader :chars, :type, :hint
    def initialize(chars, type, hint)
      @chars = chars
      @type = type
      @hint = hint
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
        collector += char[0] >= 'a' && char[0] <= 'z' && !Vowels.include?(char[0]) ?
                      Config.score[char[0].to_sym] : 0
      end
    end
  end

  def self.only_vowels(value, type)
    new_value, hint = split_value_and_hint(value)
    chars = new_value.split('')

    chars.map! do |v|
      hidden = is_hidden?(v) ? true : false
      [v, hidden]
    end

    Code.new(chars, type, hint)
  end

  def self.fully_hidden(value, type)
    new_value, hint = split_value_and_hint(value)
    chars = new_value.split('')

    chars.map! do |v|
      hidden = is_hidden?(v, :fully_hidden) ? true : false
      [v, hidden]
    end

    Code.new(chars, type, hint)
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