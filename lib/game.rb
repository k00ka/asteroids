# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

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

    # Our space contains four types of things
    @player = Player.new(@@dt)

    # Ready...set...play!
    @player.add_to_space(@space)
  end

  # Gosu calls this method first - to update the model, which in this case is stored in Chipmunk
  def update
    # UPDATE THE MODEL
    # Step time forward in Chipmunk - update the model and call any collision callbacks
    @space.step(@@dt)

    @player.apply_damping # slows down movement over time
    @player.accelerate(accelerate_control_pressed)
    @player.hyperspace(hyperspace_control_pressed)
    @player.turn(turn_right_control_pressed, turn_left_control_pressed)
    @player.wrap_to_screen
  end

  def draw
    @player.draw
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
