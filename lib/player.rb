#Encoding: UTF-8

class Player
  @@ship_image = Gosu::Image.new("media/ship.bmp")
  @@thrust_image = Gosu::Image.new("media/shipthrust.bmp")
  @@facing_upward =  3*Math::PI/2.0
  @@zero_vector = CP::Vec2.new(0.0, 0.0)

  def initialize
    # In order to create a shape, we must first define it
    # Chipmunk defines 3 types of Shapes: Segments, Circles and Polys
    # We'll use a simple, 4 sided Poly for our Player (ship)
    # You need to define the vectors so that the "top" of the Shape is towards 0 radians (the right)
    shape_array = [CP::Vec2.new(-25.0, -25.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 1.0), CP::Vec2.new(25.0, -1.0)]
    @shape = CP::Shape::Poly.new(default_body, shape_array, @@zero_vector)

    # The collision_type of a shape allows us to set up special collision behavior
    # based on these types.  The actual value for the collision_type is arbitrary
    # and, as long as it is consistent, will work for us; of course, it helps to have it make sense
    @shape.collision_type = :ship

    @shape.body do |body|
      body.p = @@zero_vector # position
      body.v = @@zero_vector # velocity
      body.a = @@facing_upward
    end
  end

  def add_to_space(space)
    space.add_body(@shape.body)
    space.add_shape(@shape)
  end

  def remove_from_space(space)
    space.remove_body(@shape.body)
    space.remove_shape(@shape)
  end

  def accelerate_none
    @accelerating = false
  end

  def reset_forces
    @shape.body.reset_forces
  end

  def apply_damping
    @shape.body.update_velocity(@@zero_vector, 0.997, 1.0/60.0)
  end

  # Directly set the position of our Player
  def warp(vect)
    @shape.body.p = vect
  end

  # Turn a constant speed cw
  def turn_right(rate = 6.0)
    @shape.body.w = rate
  end

  # Turn a constant speed ccw
  def turn_left(rate = 6.0)
    turn_right(-rate)
  end

  def turn_none
    turn_right(0.0)
  end

  # Apply forward force; Chipmunk will do the rest
  # Here we must convert the angle (facing) of the body into
  # forward momentum by creating a vector in the direction of the facing
  # and with a magnitude representing the force we want to apply
  def accelerate(force = 3000.0)
    @shape.body.apply_force((radians_to_vec2(@shape.body.a) * force), @@zero_vector)
    @accelerating = true
  end

  # Wrap to the other side of the screen when we fly off the edge
  def validate_position
    @shape.body.p = CP::Vec2.new(@shape.body.p.x % WIDTH, @shape.body.p.y % HEIGHT)
  end

  def draw
    image = @accelerating ? @@thrust_image : @@ship_image
    image.draw_rot(@shape.body.p.x, @shape.body.p.y, ZOrder::Player, @shape.body.a.radians_to_gosu)
  end

private
  # Convenience method for converting from radians to a Vec2 vector.
  def radians_to_vec2(radians)
    CP::Vec2.new(Math::cos(radians), Math::sin(radians))
  end

  def default_body
    CP::Body.new(10.0, 150.0)
  end
end
