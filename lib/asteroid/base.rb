# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

require_relative '../body'
#require_relative '../circle'

module Asteroid
  class Base < Body
    attr_reader :image, :shape
    attr_writer :shape if defined? RSpec

    @@asteroids = []
    @@white = 0xff_ffffff

    # accept position, so that it can be set when an asteroid is split
    def initialize(position = self.class.random_position_near_edge)
      super default_shape

      self.position = position
      self.velocity = self.class.random_velocity
      self.angle = facing_upward

      @image = self.class.random_asteroid_image
      #@collision_circle = Gosu::Image.new(Circle.new(scale * 26.0 / 2.0), false)
    end

    def self.split_all(asteroids)
      asteroids.each do |asteroid|
        @@asteroids.delete(asteroid)
        @@asteroids.concat(asteroid.split)
      end
    end

    def split
      self.class.random_boom_sound.play
      remove_from_space(@@space) # remove the original piece
      chunks.each { |chunk| chunk.add_to_space(@@space) } # add chunks, if any
    end

    def self.total_scale
      @@asteroids.map(&:scale).inject(0, &:+)
    end

    def self.any?
      @@asteroids.any?
    end

    def self.draw_all
      @@asteroids.each(&:draw)
    end

    def draw
      @image.draw_rot(self.position.x, self.position.y, ZOrder::Asteroids, 0, 0.5, 0.5, 1, 1, @@white, :add)
      #@collision_circle.draw_rot(self.position.x, self.position.y, ZOrder::Asteroids, 0, 0.5, 0.5, 1, 1, @@white, :add)
    end

    def self.wrap_all_to_screen
      @@asteroids.each(&:wrap_to_screen)
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

    def self.random_velocity
      direction = (rand * 32).to_i * Math::PI / 16
      speed = 75 * (1 + (rand * 4).to_i / 3)
      calc_velocity(direction, speed)
    end

    def default_body
      CP::Body.new(10.0, 150.0)
    end

    def default_shape
      scaled_radius = scale * 26.0 / 2.0 
      CP::Shape::Circle.new(default_body, scaled_radius, CP::Vec2.new(0.0, 0.0)).tap do |s|
        s.collision_type = :asteroid
        s.object = self
      end
    end
  end
end
