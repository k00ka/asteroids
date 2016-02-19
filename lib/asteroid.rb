#Encoding: UTF-8

class Asteroid
  attr_reader :shape

  def initialize(animation, shape)
    @animation = animation
    @shape = shape
    @color = random_color
    @shape.body.p = CP::Vec2.new(rand * WIDTH, rand * HEIGHT) # position
    @shape.body.v = CP::Vec2.new(0.0, 0.0) # velocity
    @shape.body.a = 3 * Math::PI / 2.0 # angle in radians; faces towards top of screen
  end

  def draw
    img = @animation[Gosu::milliseconds / 100 % @animation.size]
    img.draw(@shape.body.p.x - img.width / 2.0, @shape.body.p.y - img.height / 2.0, ZOrder::Asteroids, 1, 1, @color, :add)
  end

  private

  def random_color
    bright_color = -> { rand(255 - 40) + 40 }
    Gosu::Color.new(0xff_000000).tap do |c|
      c.red = bright_color.call
      c.green = bright_color.call
      c.blue = bright_color.call
    end
  end
end
