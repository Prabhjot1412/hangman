require_relative 'lib/lib.rb'

VALUE_COLLECTION = {
  movie: I18n.t('movies').uniq.shuffle,
  game: I18n.t('video_games').uniq.shuffle,
  anime: I18n.t('anime.titles').uniq.shuffle,
  tv_show: I18n.t('tv_shows').uniq.shuffle
}

class Config
  attr_accessor :categories

  attr_reader :starting_lifes, :hints, :cheat_mode
  def initialize(difficulty: 10)
    @categories = {
                    movie: [true, "VALUE_COLLECTION[:movie].first(#{difficulty}).sample"],
                    game: [true, "VALUE_COLLECTION[:game].first(#{difficulty}).sample"],
                    anime: [true, "VALUE_COLLECTION[:anime].first(#{difficulty}).sample"],
                    tv_show: [true, "VALUE_COLLECTION[:tv_show].first(#{difficulty}).sample"],
                  }

    @starting_lifes = 5
    @hints = true # turning this on will show hint when low on lives if present.
    @cheat_mode = true # type win to win the game
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
