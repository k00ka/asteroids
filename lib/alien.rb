# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

require_relative 'body'
require_relative 'shot'

class Alien < Body
  attr_reader :destroyed

  @@large_alien_image = Gosu::Image.new("media/alienlrg.bmp")
  @@small_alien_image = Gosu::Image.new("media/alienlrg.bmp")
  @@speed = 150

  def initialize(shots)
    super default_shape
    @shots = shots

    self.position.y = rand * HEIGHT
    self.angle = facing_upward
    @horizontal_direction = [-1, 1].sample
    update_flight_path
  end

  def points
    500
  end

  def draw
    @@large_alien_image.draw_rot(position.x, position.y, ZOrder::Aliens, 0.0)
  end

  def shoot(space)
    angle = random_angle
    location_of_gun = position + self.class.radians_to_vec2(angle) * 25
    Shot.new(location_of_gun, angle).tap do |s|
      @shots << s
      s.add_to_space(space)
    end
  end

  def update_flight_path
    np = new_phase
    return if np == @phase
    @phase = np
    if @phase == :outer
      direction = (1-@horizontal_direction)*Math::PI/2
    else
      direction = [2-@horizontal_direction, 6+@horizontal_direction].sample*Math::PI/4
    end
    self.velocity = self.class.calc_velocity(direction, @@speed)
  end

  def new_phase
    return :outer if position.x > 2*WIDTH/3 || position.x < WIDTH/3 # flies horizontal
    :inner #angled
  end

  def reached_endpoint?
    position.x == 0 || position.x == WIDTH
  end

private
  def default_shape
    shape_array = [CP::Vec2.new(-16.0, -14.0), CP::Vec2.new(-16.0, 14.0), CP::Vec2.new(-6.0, 28.0), CP::Vec2.new(16.0, 8.0), CP::Vec2.new(16.0, -8.0), CP::Vec2.new(-6.0, -28.0)]
    CP::Shape::Poly.new(default_body, shape_array).tap do |s|
      s.collision_type = :alien
      s.object = self
    end
  end

  def random_angle
    rand * 4*Math::PI/2
  end
end
