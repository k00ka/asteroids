#Encoding: UTF-8

class Asteroid
# See how simple our asteroid is?
# Of course... it just sits around and looks good...
  attr_reader :shape
  
  def initialize(animation, shape)
    @animation = animation
    @color = Gosu::Color.new(0xff_000000)
    @color.red = rand(255 - 40) + 40
    @color.green = rand(255 - 40) + 40
    @color.blue = rand(255 - 40) + 40
    @shape = shape
    @shape.body.p = CP::Vec2.new(rand * WIDTH, rand * HEIGHT) # position
    @shape.body.v = CP::Vec2.new(0.0, 0.0) # velocity
    @shape.body.a = (3*Math::PI/2.0) # angle in radians; faces towards top of screen
  end

  def draw  
    img = @animation[Gosu::milliseconds / 100 % @animation.size];
    img.draw(@shape.body.p.x - img.width / 2.0, @shape.body.p.y - img.height / 2.0, ZOrder::Asteroids, 1, 1, @color, :add)
  end
end
