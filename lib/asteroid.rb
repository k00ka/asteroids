#Encoding: UTF-8

class Asteroid
  attr_reader :shape, :chunk

  def self.random_large_asteroid_image
    @@large_asteroid_images ||= [
      Gosu::Image.new("media/astlrg1.bmp"),
      Gosu::Image.new("media/astlrg2.bmp"),
      Gosu::Image.new("media/astlrg3.bmp"),
      Gosu::Image.new("media/astlrg4.bmp")
    ]
    @@large_asteroid_images.sample
  end

  def self.random_medium_asteroid_image
    @@medium_asteroid_images ||= [
      Gosu::Image.new("media/astmed1.bmp"),
      Gosu::Image.new("media/astmed2.bmp"),
      Gosu::Image.new("media/astmed3.bmp"),
      Gosu::Image.new("media/astmed4.bmp")
    ]
    @medium_asteroid_images.sample
  end

  def self.random_small_asteroid_image
    @@small_asteroid_images ||=  [
      Gosu::Image.new("media/astsml1.bmp"),
      Gosu::Image.new("media/astsml2.bmp"),
      Gosu::Image.new("media/astsml3.bmp"),
      Gosu::Image.new("media/astsml4.bmp")
    ]
    @@small_asteroid_images.sample
  end

  def initialize(shape, chunk = 2, image = nil)
    @image = image || self.class.random_large_asteroid_image
    @shape = shape
    @chunk = chunk
    @color = Gosu::Color.new(0xff_ffffff)

    @shape.body.p = CP::Vec2.new(rand * WIDTH, rand * HEIGHT) # position
    @shape.body.v = self.class.random_velocity
    @shape.body.a = 3 * Math::PI / 2.0 # angle in radians; faces towards top of screen
    @shape.object = self
  end

  def self.random_velocity
    direction = (rand * 32).to_i / 16
    speed = 75 * (1 + (rand * 4).to_i / 3)
    CP::Vec2.new(Math::cos(direction), Math::sin(direction)) * speed/SUBSTEPS
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
  #
  # Wrap to the other side of the screen when asteroid moves off edge
  def validate_position
    l_position = CP::Vec2.new(@shape.body.p.x % WIDTH, @shape.body.p.y % HEIGHT)
    @shape.body.p = l_position
  end
end
