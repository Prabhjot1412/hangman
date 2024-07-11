
class Config
  require_relative 'lib/lib.rb'

  attr_accessor :categories

  attr_reader :starting_lifes, :hints
  def initialize()
    @categories = {
                    movie: [true, "I18n.t('movies').uniq.sample"],
                    game: [true, "I18n.t('video_games').uniq.sample"],
                    anime: [true, "I18n.t('anime.titles').uniq.sample"],
                    tv_show: [true, "I18n.t('tv_shows').uniq.sample"],
                  }

    @starting_lifes = 5
    @hints = false
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
