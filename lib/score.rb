# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

class Score
  attr_reader :reward_free_ship

  def initialize
    @score = 0
    @font = Gosu::Font.new(70, name: "media/Hyperspace.ttf")
  end

  def increment(points)
    @score += points
    @reward_free_ship = reward_free_ship?(points)
  end

  # draw the score leftward from top-right
  def draw_at(right = 200, top = 10)
    @font.draw_rel(@score > 0 ? @score : "00", right, top, ZOrder::UI, 1.0, 0.0)
  end

private
  def reward_free_ship?(points)
    # did we just pass 10k?
    (@score - points).div(10000) != @score.div(10000)
  end
end
