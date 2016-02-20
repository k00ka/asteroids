#Encoding: UTF-8

class Asteroid
  attr_reader :shape, :chunk

  def self.random_large_asteroid_image
    @@large_asteroid_image1 ||= Gosu::Image.new("media/astsml1.bmp")
    @@large_asteroid_image2 ||= Gosu::Image.new("media/astsml2.bmp")
    rand > 0.5 ? @@large_asteroid_image1 : @@large_asteroid_image2
  end

  def self.random_medium_asteroid_image
    @@medium_asteroid_image1 ||= Gosu::Image.new("media/astsml1.bmp")
    @@medium_asteroid_image2 ||= Gosu::Image.new("media/astsml2.bmp")
    rand > 0.5 ? @@medium_asteroid_image1 : @@medium_asteroid_image2
  end

  def self.random_small_asteroid_image
    @@small_asteroid_image1 ||= Gosu::Image.new("media/astsml1.bmp")
    @@small_asteroid_image2 ||= Gosu::Image.new("media/astsml2.bmp")
    rand > 0.5 ? @@small_asteroid_image1 : @@small_asteroid_image2
  end

  def initialize(shape, chunk = 2, image = nil)
    @image = image || self.class.random_large_asteroid_image
    @shape = shape
    @chunk = chunk
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

  def chunks
    return [] if @chunk.zero?
    (0...@chunk).map { self.class.new(self.class.cp_shape, @chunk - 1, @image) }
  end
end
