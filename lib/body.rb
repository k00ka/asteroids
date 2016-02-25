# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

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
  def wrap_to_screen
    self.position = CP::Vec2.new(self.position.x % WIDTH, self.position.y % HEIGHT)
  end

  if defined? RSpec
    def body
      @shape.body
    end
  end

protected
  # "zero" position
  def dead_center 
    CP::Vec2.new(WIDTH/2, HEIGHT/2)
  end

  def self.random_position
    CP::Vec2.new(rand * WIDTH, rand * HEIGHT)
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

  # Convenience method for converting from radians to a Vec2 vector.
  def self.radians_to_vec2(radians)
    CP::Vec2.new(Math::cos(radians), Math::sin(radians))
  end

  def self.calc_velocity(direction, speed)
    radians_to_vec2(direction) * speed
  end

private
  def default_body
    CP::Body.new(0.0001, 0.0001)
  end

  def self.random_boom_sound
    @@boom_sounds = [
      Gosu::Sample.new("media/boom1.wav"),
      Gosu::Sample.new("media/boom2.wav"),
      Gosu::Sample.new("media/boom3.wav")
    ]
    @@boom_sounds.sample
  end
end
