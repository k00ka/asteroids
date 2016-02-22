#Encoding: UTF-8

module Asteroid
  class Base
    attr_reader :image, :shape, :body

    @@boom_sound = Gosu::Sample.new("media/boom.wav")
    @@white = Gosu::Color.new(0xff_ffffff)
    @@facing_upward =  3*Math::PI/2.0

    def initialize(position = CP::Vec2.new(rand * WIDTH, rand * HEIGHT))
      @image = self.class.random_asteroid_image
      @shape = shape || default_shape
      @shape.object = self
      @body = @shape.body.tap do |b|
        b.p = position
        b.v = self.class.random_velocity
        b.a = @@facing_upward
      end
    end

    def validate_position
      @shape.body.p = CP::Vec2.new(@shape.body.p.x % WIDTH, @shape.body.p.y % HEIGHT)
    end

    def split(space)
      @@boom_sound.play
      remove_from_space(space)
      chunks.each { |chunk| chunk.add_to_space(space) }
    end

    def add_to_space(space)
      space.add_body(shape.body)
      space.add_shape(shape)
    end

    def remove_from_space(space)
      space.remove_body(shape.body)
      space.remove_shape(shape)
    end

    def draw
      #scaled_width = @image.width * scale / 2.0
      #scaled_height = @image.height * scale / 2.0
      #@image.draw(@shape.body.p.x - scaled_width, @shape.body.p.y - scaled_height, ZOrder::Asteroids, scale, scale, @color, :add)
      @image.draw(@shape.body.p.x - @image.width / 2.0, @shape.body.p.y - @image.height / 2.0, ZOrder::Asteroids, 1, 1, @@white, :add)
    end

    protected
    def self.random_asteroid_image
      size = name.gsub(/^.*::/,"").downcase
      @@asteroid_images = [
        Gosu::Image.new("media/ast#{size}1.bmp"),
        Gosu::Image.new("media/ast#{size}2.bmp"),
        Gosu::Image.new("media/ast#{size}3.bmp"),
        Gosu::Image.new("media/ast#{size}4.bmp")
      ]
      @@asteroid_images.sample
    end

    def default_body
      CP::Body.new(0.0001, 0.0001)
    end

    def default_shape
      scaled_radius = 25.to_f / 2 * scale
      CP::Shape::Circle.new(default_body, scaled_radius, CP::Vec2.new(0.0, 0.0)).tap do |s|
        s.collision_type = :asteroid
      end
    end

    def self.random_velocity
      direction = (rand * 32).to_i * Math::PI / 16
      speed = 75 * (1 + (rand * 4).to_i / 3)
      CP::Vec2.new(Math::cos(direction), Math::sin(direction)) * speed
    end
  end
end
