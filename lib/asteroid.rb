#Encoding: UTF-8

class Asteroid
  attr_reader :shape, :spawn

  def self.default_animation=(animation)
    @@animation = animation
  end

  def self.default_animation
    @@animation ||= Gosu::Image.load_tiles("media/astsml1.bmp", 26, 26)
  end

  def initialize(shape, spawn = 2, animation: nil)
    @animation = animation || self.class.default_animation
    @shape = shape
    @spawn = spawn
    @color = random_color

    @shape.body.p = CP::Vec2.new(rand * WIDTH, rand * HEIGHT) # position
    @shape.body.v = CP::Vec2.new(0.0, 0.0) # velocity
    @shape.body.a = 3 * Math::PI / 2.0 # angle in radians; faces towards top of screen
    @shape.object = self
  end

  def self.cp_shape
    CP::Shape::Circle.new(CP::Body.new(0.0001, 0.0001), 25/2, CP::Vec2.new(0.0, 0.0)).tap do |s|
      s.collision_type = :asteroid
    end
  end

  def draw
    img = @animation[Gosu::milliseconds / 100 % @animation.size]
    img.draw(@shape.body.p.x - img.width / 2.0, @shape.body.p.y - img.height / 2.0, ZOrder::Asteroids, 1, 1, @color, :add)
  end

  def score
    10
  end

  def spawns
    return [] if @spawn.zero?
    (0...@spawn).map { self.class.new(self.class.cp_shape, @spawn - 1, animation: @animation) }
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
