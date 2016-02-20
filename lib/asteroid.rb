#Encoding: UTF-8

class Asteroid
  attr_reader :shape, :spawn

  def self.default_image=(image)
    @@image = image
  end

  def self.default_image
    @@image ||= Gosu::Image.new("media/astsml1.bmp")
  end

  def initialize(shape, spawn = 2, image = nil)
    @image = image || self.class.default_image
    @shape = shape
    @spawn = spawn
    @color = Gosu::Color.new(0xff_ffffff)

    @shape.body.p = CP::Vec2.new(rand * WIDTH, rand * HEIGHT) # position
    @shape.body.v = CP::Vec2.new(5.0, 5.0) # velocity
    @shape.body.a = 3 * Math::PI / 2.0 # angle in radians; faces towards top of screen
    @shape.object = self
  end

  def self.cp_shape
    CP::Shape::Circle.new(CP::Body.new(0.0001, 0.0001), 25/2, CP::Vec2.new(0.0, 0.0)).tap do |s|
      s.collision_type = :asteroid
    end
  end

  def draw
    @image.draw(@shape.body.p.x - @image.width / 2.0, @shape.body.p.y - @image.height / 2.0, ZOrder::Asteroids, 1, 1, @color, :add)
  end

  def score
    10
  end

  def spawns
    return [] if @spawn.zero?
    (0...@spawn).map { self.class.new(self.class.cp_shape, @spawn - 1, @image) }
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
