#Encoding: UTF-8

require_relative 'zorder'
require_relative 'player'
require_relative 'asteroid'
require_relative 'level'

# The number of steps to process every Gosu update
# The Player ship can get going so fast as to "move through" a
# asteroid without triggering a collision; an increased number of
# Chipmunk step calls per update will effectively avoid this issue
SUBSTEPS = 6

# The Gosu::Window is always the "environment" of our game
# It also provides the pulse of our game
class Game < Gosu::Window
  def initialize
    super WIDTH, HEIGHT

    self.caption = "Ruby Hack Night Asteroids"

    # Put the beep here, as it is the environment now that determines collision
    @beep = Gosu::Sample.new("media/boom.wav")

    # Put the score here, as it is the environment that tracks this now
    @score = 0
    @font = Gosu::Font.new(70, name: "media/hyperspace.ttf")

    # Time increment over which to apply a physics "step" ("delta t")
    @dt = 1.0/60.0

    # Create our Space and set its damping
    # A damping of 0.8 causes the ship bleed off its force and torque over time
    # This is not realistic behavior in a vacuum of space, but it gives the game
    # the feel I'd like in this situation
    @space = CP::Space.new

    # Create the Body for the Player
    body = CP::Body.new(10.0, 150.0)

    # In order to create a shape, we must first define it
    # Chipmunk defines 3 types of Shapes: Segments, Circles and Polys
    # We'll use a simple, 4 sided Poly for our Player (ship)
    # You need to define the vectors so that the "top" of the Shape is towards 0 radians (the right)
    shape_array = [CP::Vec2.new(-25.0, -25.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 1.0), CP::Vec2.new(25.0, -1.0)]
    shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))

    # The collision_type of a shape allows us to set up special collision behavior
    # based on these types.  The actual value for the collision_type is arbitrary
    # and, as long as it is consistent, will work for us; of course, it helps to have it make sense
    shape.collision_type = :ship

    @space.add_body(body)
    @space.add_shape(shape)

    @player = Player.new(shape)
    @player.warp(CP::Vec2.new(WIDTH/2, HEIGHT/2)) # move to the center of the window

    @asteroids = Array.new
    @level = Level.new(@space, @asteroids)

    # Here we define what is supposed to happen when a Player (ship) collides with a asteroid
    # I create a @remove_shapes array because we cannot remove either Shapes or Bodies
    # from Space within a collision closure, rather, we have to wait till the closure
    # is through executing, then we can remove the Shapes and Bodies
    # In this case, the Shapes and the Bodies they own are removed in the Gosu::Window.update phase
    # by iterating over the @remove_shapes array
    # Also note that both Shapes involved in the collision are passed into the closure
    # in the same order that their collision_types are defined in the add_collision_func call
    @split_asteroids = []
    @remove_shapes = []
    @space.add_collision_func(:ship, :asteroid) do |ship_shape, asteroid_shape|
      asteroid = asteroid_shape.object

      @score += asteroid.score
      @beep.play

      @split_asteroids.concat(asteroid.chunks)
      @remove_shapes << asteroid_shape
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
    # Step the physics environment SUBSTEPS times each update
    SUBSTEPS.times do
      # This iterator makes an assumption of one Shape per asteroid making it safe to remove
      # each Shape's Body as it comes up
      # If our asteroids had multiple Shapes, as would be required if we were to meticulously
      # define their true boundaries, we couldn't do this as we would remove the Body
      # multiple times
      # We would probably solve this by creating a separate @remove_bodies array to remove the Bodies
      # of the asteroids that were gathered by the Player
      @remove_shapes.each do |shape|
        @asteroids.delete(shape.object) if shape.object.is_a? Asteroid
        @space.remove_body(shape.body)
        @space.remove_shape(shape)
      end
      @remove_shapes.clear # clear out the shapes for next pass

      # add new asteroids to the world
      @split_asteroids.each do |ast|
        @asteroids << ast
        @space.add_body(ast.shape.body)
        @space.add_shape(ast.shape)
      end
      @split_asteroids.clear
      @asteroids.each { |a| a.validate_position }

      # When a force or torque is set on a Body, it is cumulative
      # This means that the force you applied last SUBSTEP will compound with the
      # force applied this SUBSTEP; which is probably not the behavior you want
      # We reset the forces on the Player each SUBSTEP for this reason
      @player.shape.body.reset_forces

      # Wrap around the screen to the other side
      @player.validate_position
      @player.apply_damping
      @player.turn_none

      # Check keyboard
      @player.turn_right if Gosu::button_down?(Gosu::KbRight) && !Gosu::button_down?(Gosu::KbLeft)
      @player.turn_left if Gosu::button_down?(Gosu::KbLeft) && !Gosu::button_down?(Gosu::KbRight)
      @player.accelerate if Gosu::button_down?(Gosu::KbUp)

      # Perform the step over @dt period of time
      # For best performance @dt should remain consistent for the game
      @space.step(@dt)
    end

    # Each update (not SUBSTEP) we see if we need to add more asteroids
    @level.next! if @level.complete?
  end

  def draw
    @player.draw
    @asteroids.each { |asteroid| asteroid.draw }
    @font.draw_rel(@score > 0 ? @score : "00", 200, 10, ZOrder::UI, 1.0, 0.0)
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end
end
