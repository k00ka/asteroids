# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

require_relative 'asteroid/large'
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
    Asteroid::Base.space = @space

    # Our space contains four types of things
    @player = Player.new(@@dt)

    # Create some asteroids
    Asteroid::Large.create(4)

    # COLLISION CALLBACKS
    # Here are closures for object collisions for each pair of things in our space...
    @split_asteroids = []

    @space.add_collision_func(:ship, :asteroid) do |ship_shape, asteroid_shape|
      next if ship_shape.object.invulnerable?
      @player.destroyed!
      @split_asteroids << asteroid_shape.object
    end

    # Cause like objects to ignore each other, rather than bumping into one another
    @space.add_collision_func(:asteroid, :asteroid, &nil)

    # SOUNDS
    @high_doop = Gosu::Sample.new("media/high.wav")
    @low_doop = Gosu::Sample.new("media/low.wav")

    # Ready...set...play!
    @player.add_to_space(@space)
  end

  # Gosu calls this method first - to update the model, which in this case is stored in Chipmunk
  def update
    # UPDATE THE MODEL
    # Step time forward in Chipmunk - update the model and call any collision callbacks
    @space.step(@@dt)

    # PLAYER
    if @player.destroyed
      @player.new_ship
    else
      @player.apply_damping # slows down movement over time
      @player.accelerate(accelerate_control_pressed)
      @player.hyperspace(hyperspace_control_pressed)
      @player.turn(turn_right_control_pressed, turn_left_control_pressed)
      @player.wrap_to_screen
    end

    # ASTEROIDS
    Asteroid::Base.split_all(@split_asteroids)
    @split_asteroids.clear
    Asteroid::Base.wrap_all_to_screen

    conditionally_play_doop
  end

  def draw
    Asteroid::Base.draw_all
    @player.draw
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end

private
  def conditionally_play_doop
    @last_doop_time ||= Gosu.milliseconds
    doop_delay = Asteroid::Base.total_scale * 80 + 80
    if @last_doop_time + doop_delay < Gosu.milliseconds
      @doop_sound = (@doop_sound == @high_doop) ? @low_doop : @high_doop
      @doop_sound.play
      @last_doop_time = Gosu.milliseconds
    end
  end

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
