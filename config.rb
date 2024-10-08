require_relative 'lib/lib.rb'

VALUE_COLLECTION = {
  movie: I18n.t('movies').uniq.shuffle,
  game: I18n.t('video_games').uniq.shuffle,
  anime: I18n.t('anime.titles').uniq.shuffle,
  tv_show: I18n.t('tv_shows').uniq.shuffle
}

class Config
  attr_accessor :random_letters_revealed,
  :lifes, :fog, :revealed_letters, :bargain_frequency, :life_gain,
  :loose_half_life_on_wrong_guess, :gain_life_on_right_guess, :hint_life_threshold,
  :hint_after_this_many_attempts, :hints_disabled, :pay_cost,
  :skip_puzzle_on_solve, :boons_to_choose_from, :bargain_cost, :life_cap,
  :categories

  attr_reader :hints, :cheat_mode, :hide_mode, :difficulty, :debug_mode
  def initialize(difficulty: 255)
    @categories = {
                    movie:   [true, "VALUE_COLLECTION[:movie].first(#{difficulty}).sample"],
                    game:    [true, "VALUE_COLLECTION[:game].first(#{difficulty}).sample"],
                    anime:   [true, "VALUE_COLLECTION[:anime].first(#{difficulty}).sample"],
                    tv_show: [true, "VALUE_COLLECTION[:tv_show].first(#{difficulty}).sample"],
                  }

    @lifes = 5
    @hints = true # turning this on will show hint when low on lives if present.
    @cheat_mode = true # type win to win the game
    @debug_mode = true # enter debugger with debug
    @hide_mode = 'random_revealed' # 'only_vowels' 'fully_hidden' 'random_revealed'
    @random_letters_revealed = 5
    @difficulty = difficulty
    @bargain_frequency = 5
    @life_gain = 1
    @hint_after_this_many_attempts = 2
    @hint_life_threshold = 4
    @pay_cost = 8
    @skip_puzzle_on_solve = {chance: 0, stack: 0}
    @boons_to_choose_from = 3
    @bargain_cost = 0
    @life_cap = nil

    @fog = 0
    @revealed_letters = []
    @loose_half_life_on_wrong_guess = 0
    @gain_life_on_right_guess = 0
    @hints_disabled = false
  end

  def self.score
  {
    a: 3,
    b: 4,
    c: 4,
    d: 3,
    e: 3,
    f: 4,
    g: 4,
    h: 3,
    i: 3,
    j: 5,
    k: 3,
    l: 4,
    m: 2,
    n: 2,
    o: 3,
    p: 5,
    q: 7,
    r: 3,
    s: 4,
    t: 2,
    u: 3,
    v: 6,
    w: 8,
    x: 9,
    y: 9,
    z: 9
  }
  end
end

String.class_eval do
  def humanize
    str = self.capitalize
    str.gsub('-', ' ')
  end
end
