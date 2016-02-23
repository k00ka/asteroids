class Dock
  @@image = Gosu::Image.new("media/miniship.bmp")

  def initialize(count = 2)
    @count = count - 1
  end

  def fetch_ship
    @count -= 1
  end

  def free_ship
    @count += 1
  end

  def empty?
    @count == 0
  end

  def draw_at(x, y)
    # the dock includes an image of your current ship
    (@count+1).times do |i|
      @@image.draw(x+(i*20), y, ZOrder::Player)
    end
  end
end
