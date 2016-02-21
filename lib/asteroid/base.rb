#Encoding: UTF-8

module Asteroid
  class Base
    def initialize(shape: nil)
      @image = default_image
      @shape = shape || default_shape
      @shape.object = self
      @body = @shape.body.tap do |b|
        b.p = CP::Vec2.new(rand * WIDTH, rand * HEIGHT) # position
        b.v = CP::Vec2.new(5.0, 5.0) # velocity
        b.a = 3 * Math::PI / 2.0 # angle in radians; faces towards top of screen
      end
    end

    def draw
      @image.draw(@shape.body.p.x - @image.width / 2.0, @shape.body.p.y - @image.height / 2.0, ZOrder::Asteroids, 1, 1, @color, :add)
    end

    protected

    def default_body
      CP::Body.new(0.0001, 0.0001)
    end

    def default_shape
      CP::Shape::Circle.new(default_body, 25/2, CP::Vec2.new(0.0, 0.0)).tap do |s|
        s.collision_type = :asteroid
      end
    end
  end
end
