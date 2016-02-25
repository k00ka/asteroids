# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

class Dock
  @@image = Gosu::Image.new("media/miniship.bmp")
  @@font = Gosu::Font.new(70, name: "media/Hyperspace.ttf")
  @@free_ship_sound = Gosu::Sample.new("media/freeship.wav")

  def initialize(ship_count = 3)
    @score = 0
    @ship_count = ship_count
  end

  def increment_score(points)
    @score += points
    if reward_free_ship?(points)
      @ship_count += 1
      @@free_ship_sound.play
    end
  end

  def use_ship
    @ship_count -= 1
  end

  def no_ships?
    @ship_count <= 0
  end

  # draw the score leftward from top-right
  def draw_at(right = 200, top = 10)
    @@font.draw_rel(@score > 0 ? @score : "00", right, top, ZOrder::UI, 1.0, 0.0)
    # (strangely) this incudes an image of your current ship
    @ship_count.times { |i| @@image.draw(right-80+i*@@image.width, top+70, ZOrder::UI) }
  end

private
  def reward_free_ship?(points)
    # did we just pass 10k?
    (@score - points).div(10000) != @score.div(10000)
  end
end
