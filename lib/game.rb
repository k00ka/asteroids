#Encoding: UTF-8

require_relative 'zorder'
require_relative 'player'
require_relative 'asteroid/large'
require_relative 'level'
require_relative 'score'

# The Gosu::Window is always the "environment" of our game
# It also provides the pulse of our game
class Game < Gosu::Window
  def initialize
    super WIDTH, HEIGHT

    self.caption = "Ruby Hack Night Asteroids"

    # Put the beep here, as it is the environment now that determines collision
    @high = Gosu::Sample.new("media/high.wav")
    @low = Gosu::Sample.new("media/low.wav")

    # Put the score here, as it is the environment that tracks this now
    @score = Score.new

    # Time increment over which to apply a physics "step" ("delta t")
    @dt = 1.0/60.0

    # Create our Space and set its damping
    # A damping of 0.8 causes the ship bleed off its force and torque over time
    # This is not realistic behavior in a vacuum of space, but it gives the game
    # the feel I'd like in this situation
    @space = CP::Space.new

    @player = Player.new
    @player.add_to_space(@space)
    @player.warp(CP::Vec2.new(WIDTH/2, HEIGHT/2)) # move to the center of the window

    @asteroids = Array.new
    @level = Level.new(@space, @asteroids)

    # Here we define what is supposed to happen when a Player (ship) collides with a asteroid
    # Also note that both shapes involved in the collision are passed into the closure
    # in the same order that their collision_types are defined in the add_collision_func call
    @split_asteroids = []
    @space.add_collision_func(:ship, :asteroid) do |ship_shape, asteroid_shape|
      @split_asteroids << asteroid_shape.object
    end

    # Here we tell Space that we don't want one asteroid bumping into another
    # The reason we need to do this is because when the Player hits a asteroid,
    # the asteroid will travel until it is removed in the update cycle below
    # which means it may collide and therefore push other asteroids
    # To see the effect, remove this line and play the game, every once in a while
    # you'll see a asteroid moving
    @space.add_collision_func(:asteroid, :asteroid, &nil)
  end

  def update
    # for each asteroid collision
    @split_asteroids.each do |asteroid|
      @asteroids.delete(asteroid)
      @asteroids.concat(asteroid.split(@space))
      @score.increment(asteroid.points)
    end
    @split_asteroids.clear
    @asteroids.each(&:validate_position)

    # Adjust player forces

    # When a force or torque is set on a Body, it is cumulative
    # This means that the force you applied last SUBSTEP will compound with the
    # force applied this SUBSTEP; which is probably not the behavior you want
    # We reset the forces on the Player each SUBSTEP for this reason
    @player.reset_forces

    # Acceleration/deceleration
    @player.accelerate_none
    @player.apply_damping
    @player.accelerate if Gosu::button_down?(Gosu::KbUp)

    # Torque
    @player.turn_none
    @player.turn_right if Gosu::button_down?(Gosu::KbRight) && !Gosu::button_down?(Gosu::KbLeft)
    @player.turn_left if Gosu::button_down?(Gosu::KbLeft) && !Gosu::button_down?(Gosu::KbRight)

    @player.validate_position

    # Perform the step over @dt period of time
    # For best performance @dt should remain consistent for the game
    @space.step(@dt)

    # Each update (not SUBSTEP) we see if we need to add more asteroids
    @level.next! if @level.complete?
  end

  def draw
    @player.draw
    @asteroids.each(&:draw)
    @score.draw_at(180, 5)
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end
end
