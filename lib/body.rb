#Encoding: UTF-8

class Body
  def initialize(shape)
    @shape = shape
  end

  def position
    @shape.body.p
  end

  def position=(vector)
    @shape.body.p = vector
  end

  def velocity
    @shape.body.v
  end

  def velocity=(vector)
    @shape.body.v = vector
  end

  def angle
    @shape.body.a
  end

  def angle=(radians)
    @shape.body.a = radians
  end

  def spin
    @shape.body.w
  end

  def spin=(rate)
    @shape.body.w = rate
  end

  # For Game class...
  def add_to_space(space)
    space.add_body(@shape.body)
    space.add_shape(@shape)
  end

  def remove_from_space(space)
    space.remove_body(@shape.body)
    space.remove_shape(@shape)
  end

  # Wrap to the other side of the screen when something goes off the edge
  def validate_position
    self.position = CP::Vec2.new(self.position.x % WIDTH, self.position.y % HEIGHT)
  end

protected
  # "zero" position
  def dead_center 
    CP::Vec2.new(WIDTH/2, HEIGHT/2)
  end

  # zero velocity
  def still
    CP::Vec2.new(0.0, 0.0)
  end

  # "zero" angle
  def facing_upward
    3*Math::PI/2.0
  end

  def zero_gravity
    CP::Vec2.new(0.0, 0.0)
  end

  def zero_offset
    CP::Vec2.new(0.0, 0.0)
  end

  def self.calc_velocity(direction, speed)
    CP::Vec2.new(Math::cos(direction), Math::sin(direction)) * speed
  end
end
