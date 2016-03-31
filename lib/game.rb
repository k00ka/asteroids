# Encoding: UTF-8

# Ruby Hack Night Asteroids by me!

require_relative 'player'
require_relative 'zorder'

# The Gosu::Window is always the "environment" of our game
# It also provides the pulse of our game
class Game < Gosu::Window

  # Time increment over which to apply a physics "step" ("delta t")
  @@dt = 1.0/60.0

  def initialize
    super WIDTH, HEIGHT

    self.caption = "Ruby Hack Night Asteroids"

    # Create our Space
    @space = CP::Space.new

    # DEMO - REMOVE ME
    @image1 = Gosu::Image.new("media/ship.bmp")
    shape1_array = [CP::Vec2.new(-20.0, -13.0), CP::Vec2.new(-20.0, 14.0), CP::Vec2.new(20.0, 1.0)]
    @shape1 = CP::Shape::Poly.new(CP::Body.new(10.0, 150.0), shape1_array)
    @shape1.body.p = CP::Vec2.new(WIDTH/2+100, HEIGHT/2)
    @shape1.e = 1.0
    @shape1.body.apply_impulse(CP::Vec2.new(-400.0, 0.0), CP::Vec2.new(0.0, 0.0))
    @space.add_body(@shape1.body)
    @space.add_shape(@shape1)

    @image2 = Gosu::Image.new("media/ship.bmp")
    shape2_array = [CP::Vec2.new(-20.0, -13.0), CP::Vec2.new(-20.0, 14.0), CP::Vec2.new(20.0, 1.0)]
    @shape2 = CP::Shape::Poly.new(CP::Body.new(10.0, 150.0), shape2_array)
    @shape2.body.p = CP::Vec2.new(WIDTH/2-100, HEIGHT/2)
    @shape2.e = 1
    @shape2.body.apply_impulse(CP::Vec2.new(400.0, 0.0), CP::Vec2.new(0.0, 0.0))
    @space.add_body(@shape2.body)
    @space.add_shape(@shape2)
    # END DEMO
  end

  # Gosu calls this method first - to update the model, which in this case is stored in Chipmunk
  def update
    # UPDATE THE MODEL
    # Step time forward in Chipmunk - update the model and call any collision callbacks
    @space.step(@@dt)
  end

  def draw
    # DEMO - REMOVE ME
    @image1.draw(@shape1.body.p.x, @shape1.body.p.y, ZOrder::Player)
    @image2.draw(@shape2.body.p.x, @shape2.body.p.y, ZOrder::Player)
    # END DEMO
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end

private
  # CONTROLS
  def accelerate_control_pressed
    Gosu::button_down?(Gosu::KbUp)
  end
  def turn_right_control_pressed
    Gosu::button_down?(Gosu::KbRight)
  end
  def turn_left_control_pressed
    Gosu::button_down?(Gosu::KbLeft)
  end
  def shoot_control_pressed
    Gosu::button_down?(Gosu::KbSpace)
  end
  def hyperspace_control_pressed
    Gosu::button_down?(Gosu::KbLeftShift) || Gosu::button_down?(Gosu::KbRightShift)
  end
end
