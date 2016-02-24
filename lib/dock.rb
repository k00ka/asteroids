class Dock
  @@image = Gosu::Image.new("media/miniship.bmp")

  def initialize(count = 3)
    @count = count
  end

  def use_ship
    @count -= 1
  end

  def reward_ship
    @count += 1
  end

  def empty?
    @count <= 0
  end

  def draw_at(x, y)
    # the dock includes an image of your current ship
    @count.times do |i|
      @@image.draw(x+i*20, y, ZOrder::UI)
    end
  end
end
