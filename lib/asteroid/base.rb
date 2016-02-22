#Encoding: UTF-8

module Asteroid
  class Base

    @@images = []

    attr_reader :image, :shape, :body

    def initialize(shape: nil)
      @image = self.class.random_asteroid_image
      @shape = shape || default_shape
      @shape.object = self
      @body = @shape.body.tap do |b|
        b.p = CP::Vec2.new(rand * WIDTH, rand * HEIGHT) # position
        b.v = self.class.random_velocity
        b.a = 3 * Math::PI / 2.0 # angle in radians; faces towards top of screen
      end
      @color = Gosu::Color.new(0xff_ffffff)
    end

    def validate_position
      @shape.body.p = CP::Vec2.new(@shape.body.p.x % WIDTH, @shape.body.p.y % HEIGHT)
    end

    def draw
      #scaled_width = @image.width * scale / 2.0
      #scaled_height = @image.height * scale / 2.0
      #@image.draw(@shape.body.p.x - scaled_width, @shape.body.p.y - scaled_height, ZOrder::Asteroids, scale, scale, @color, :add)
      @image.draw(@shape.body.p.x - @image.width / 2.0, @shape.body.p.y - @image.height / 2.0, ZOrder::Asteroids, 1, 1, @color, :add)
    end

    protected

    def default_body
      CP::Body.new(0.0001, 0.0001)
    end

    def default_shape
      scaled_radius = 25.to_f / 2 * scale
      CP::Shape::Circle.new(default_body, scaled_radius, CP::Vec2.new(0.0, 0.0)).tap do |s|
        s.collision_type = :asteroid
      end
    end

    def default_image
      @@images.sample
    end

    def self.random_velocity
      direction = (rand * 32).to_i * Math::PI / 16
      speed = 75 * (1 + (rand * 4).to_i / 3)
      CP::Vec2.new(Math::cos(direction), Math::sin(direction)) * speed/SUBSTEPS
    end
  end
end
