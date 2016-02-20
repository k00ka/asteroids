#Encoding: UTF-8

class Asteroid
  attr_reader :shape
  
  def initialize(image, shape)
    @image = image
    @color = Gosu::Color.new(0xff_ffffff)
    @shape = shape
    @shape.body.p = CP::Vec2.new(rand * WIDTH, rand * HEIGHT) # position
    @shape.body.v = CP::Vec2.new(5.0, 5.0) # velocity
    @shape.body.a = (3*Math::PI/2.0) # angle in radians; faces towards top of screen
  end

  def draw  
    @image.draw(@shape.body.p.x - @image.width / 2.0, @shape.body.p.y - @image.height / 2.0, ZOrder::Asteroids, 1, 1, @color, :add)
  end
end
