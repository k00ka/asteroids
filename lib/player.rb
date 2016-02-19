#Encoding: UTF-8

class Player
# This game will have one Player in the form of a ship
  attr_reader :shape

  def initialize(shape)
    @image = Gosu::Image.new("media/ship.bmp")
    @shape = shape
    @shape.body.p = CP::Vec2.new(0.0, 0.0) # position
    @shape.body.v = CP::Vec2.new(0.0, 0.0) # velocity
    
    # Keep in mind that down the screen is positive y, which means that PI/2 radians,
    # which you might consider the top in the traditional Trig unit circle sense is actually
    # the bottom; thus 3PI/2 is the top
    @shape.body.a = (3*Math::PI/2.0) # angle in radians; faces towards top of screen
  end
  
  # Directly set the position of our Player
  def warp(vect)
    @shape.body.p = vect
  end
  
  # Apply negative Torque; Chipmunk will do the rest
  # SUBSTEPS is used as a divisor to keep turning rate constant
  # even if the number of steps per update are adjusted
  def turn_left
    @shape.body.t -= 400.0/SUBSTEPS
  end
  
  # Apply positive Torque; Chipmunk will do the rest
  # SUBSTEPS is used as a divisor to keep turning rate constant
  # even if the number of steps per update are adjusted
  def turn_right
    @shape.body.t += 400.0/SUBSTEPS
  end
  
  # Apply forward force; Chipmunk will do the rest
  # SUBSTEPS is used as a divisor to keep acceleration rate constant
  # even if the number of steps per update are adjusted
  # Here we must convert the angle (facing) of the body into
  # forward momentum by creating a vector in the direction of the facing
  # and with a magnitude representing the force we want to apply
  def accelerate
    @shape.body.apply_force((radians_to_vec2(@shape.body.a) * (3000.0/SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end
  
  # Wrap to the other side of the screen when we fly off the edge
  def validate_position
    l_position = CP::Vec2.new(@shape.body.p.x % WIDTH, @shape.body.p.y % HEIGHT)
    @shape.body.p = l_position
  end
  
  def draw
    @image.draw_rot(@shape.body.p.x, @shape.body.p.y, ZOrder::Player, @shape.body.a.radians_to_gosu)
  end
  
private
  # Convenience method for converting from radians to a Vec2 vector.
  def radians_to_vec2(radians)
    CP::Vec2.new(Math::cos(radians), Math::sin(radians))
  end
end
