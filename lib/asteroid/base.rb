#Encoding: UTF-8

require_relative '../body'

module Asteroid
  class Base < Body
    attr_reader :image, :shape
    attr_writer :shape if defined? RSpec

    @@boom_sound = Gosu::Sample.new("media/boom.wav")
    @@white = Gosu::Color.new(0xff_ffffff)

    # accept position, so that it can be set when an asteroid is split
    def initialize(position = self.class.random_position)
      super default_shape

      self.position = position
      self.velocity = self.class.random_velocity
      self.angle = self.facing_upward

      @image = self.class.random_asteroid_image
    end

    def split(space)
      @@boom_sound.play
      remove_from_space(space) # remove the original piece
      chunks.each { |chunk| chunk.add_to_space(space) } # add chunks, if any
    end

    def draw
      @image.draw_rot(self.position.x, self.position.y, ZOrder::Asteroids, 0, 0.5, 0.5, 1, 1, @@white, :add)
    end

  private
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

    def self.random_position
      CP::Vec2.new(rand * WIDTH, rand * HEIGHT)
    end

    def self.random_velocity
      direction = (rand * 32).to_i * Math::PI / 16
      speed = 75 + (1 + (rand * 4).to_i / 3)
      calc_velocity(direction, speed)
    end

    def default_body
      CP::Body.new(10.0, 150.0)
    end

    def default_shape
      scaled_radius = 25.to_f / 2 * scale
      CP::Shape::Circle.new(default_body, scaled_radius, CP::Vec2.new(0.0, 0.0)).tap do |s|
        s.collision_type = :asteroid
        s.object = self
      end
    end
  end
end
