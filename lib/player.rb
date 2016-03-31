# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

require_relative 'body'

class Player < Body
  @@ship_image = Gosu::Image.new("media/ship.bmp")
  @@thrust_image = Gosu::Image.new("media/shipthrust.bmp")
  @@thrust_sample = Gosu::Sample.new("media/thrust.wav").play(1, 1, true)
  @@thrust_sample.pause

  def initialize(dt)
    super default_shape
    @dt = dt
    #create a new_ship
  end

  def new_ship
    #self.position = dead_center
    #self.velocity = still
    #self.angle = facing_upward
  end

  def apply_damping
    @shape.body.update_velocity(zero_gravity, 0.996, @dt)
  end

  def warp_to(position)
    #self.position = position
  end

  def turn
  end

  def shoot
  end

  def hyperspace
  end

  # Apply forward force; Chipmunk will do the rest
  # Here we must convert the angle (facing) of the body into
  # forward momentum by creating a vector in the direction of the facing
  # and with a magnitude representing the force we want to apply
  def accelerate(force = 2000.0)
    @shape.body.reset_forces # When a force or torque is set on a body, it is cumulative - start from zero
    @shape.body.apply_force((self.class.radians_to_vec2(angle) * force), zero_offset)
  end

  def draw
    white = 0xff_ffffff
    @ship_image.draw_rot(position.x, position.y, ZOrder::Player, angle.radians_to_gosu, 0.5, 0.5, 1, 1, white)
  end

private
  def default_body
    CP::Body.new(10.0, 150.0)
  end

  def default_shape
    # In order to create a shape, we must first define it
    # Chipmunk defines 3 types of Shapes: Segments, Circles and Polys
    # We'll use a simple, 3 sided Poly for our Player (ship)
    # You need to define the vectors so that the "top" of the Shape is towards 0 radians (the right)
    shape_array = [CP::Vec2.new(-20.0, -13.0), CP::Vec2.new(-20.0, 14.0), CP::Vec2.new(20.0, 1.0)]
    CP::Shape::Poly.new(default_body, shape_array).tap do |s|
      # The collision_type of a shape allows us to set up special collision behavior
      # based on these types.  The actual value for the collision_type is arbitrary
      # and, as long as it is consistent, will work for us; of course, it helps to have it make sense
      s.collision_type = :ship
      s.object = self
    end
  end
end
