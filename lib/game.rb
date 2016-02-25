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
  end

  # Gosu calls this method first - to update the model, which in this case is stored in Chipmunk
  def update
    # UPDATE THE MODEL
    # Step time forward in Chipmunk - update the model and call any collision callbacks
    @space.step(@@dt)
  end

  def draw
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
