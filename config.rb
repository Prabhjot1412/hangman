require_relative 'lib/lib.rb'

VALUE_COLLECTION = {
  movie: I18n.t('movies').uniq.shuffle,
  game: I18n.t('video_games').uniq.shuffle,
  anime: I18n.t('anime.titles').uniq.shuffle,
  tv_show: I18n.t('tv_shows').uniq.shuffle
}

class Config
  attr_accessor :categories

  attr_accessor :random_letters_revealed, :lifes, :fog, :revealed_letters, :bargain_frequency
  attr_reader :hints, :cheat_mode, :hide_mode, :difficulty
  def initialize(difficulty: 250)
    @categories = {
                    movie:   [true, "VALUE_COLLECTION[:movie].first(#{difficulty}).sample"],
                    game:    [true, "VALUE_COLLECTION[:game].first(#{difficulty}).sample"],
                    anime:   [true, "VALUE_COLLECTION[:anime].first(#{difficulty}).sample"],
                    tv_show: [true, "VALUE_COLLECTION[:tv_show].first(#{difficulty}).sample"],
                  }

    @lifes = 5
    @hints = true # turning this on will show hint when low on lives if present.
    @cheat_mode = true # type win to win the game
    @hide_mode = 'random_revealed' # 'only_vowels' 'fully_hidden' 'random_revealed'
    @random_letters_revealed = 5
    @difficulty = difficulty
    @bargain_frequency = 6

    @fog = 0
    @revealed_letters = []
  end

  def self.score
  {
    b: 4,
    c: 4,
    d: 3,
    f: 4,
    g: 4,
    h: 3,
    j: 5,
    k: 3,
    l: 4,
    m: 2,
    n: 2,
    p: 5,
    q: 7,
    r: 3,
    s: 4,
    t: 2,
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
