# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

class Dock
  @@image = Gosu::Image.new("media/miniship.bmp")
  @@font = Gosu::Font.new(70, name: "media/Hyperspace.ttf")
  @@free_ship_sound = Gosu::Sample.new("media/freeship.wav")

  def initialize(ship_count = 3)
  end

  def increment_score(points)
  end

  def no_ships?
  end

  # draw the score leftward from top-right
  def draw_at(right = 200, top = 10)
  end

private
  def reward_free_ship?(points)
    # did we just pass 10k?
  end
end
