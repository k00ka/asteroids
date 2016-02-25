# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

require_relative 'asteroid/large'
require_relative 'player'
require_relative 'level'
require_relative 'alien'
require_relative 'dock'
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
    Shot.space = @space

    # Our space contains four types of things
    @asteroids = []
    @player = Player.new(@@dt)
    @aliens = []

    # Here are the game progress indicators
    @level = Level.new(@space, @asteroids)
    @dock = Dock.new(3) # this is our score and the display of ships

    # COLLISION CALLBACKS
    # Here are closures for object collisions for each pair of things in our space...
    @split_asteroids = []
    @dead_shots = []
    @dead_aliens = []
    #@dead_players = [] this would be useful for multi-player

    @space.add_collision_func(:shot, :asteroid) do |shot_shape, asteroid_shape|
      @dead_shots << shot_shape.object
      @split_asteroids << asteroid_shape.object
    end

    @space.add_collision_func(:shot, :ship) do |shot_shape, ship_shape|
      next if ship_shape.object.invulnerable?
      @dead_shots << shot_shape.object
      @player.destroyed!
    end

    @space.add_collision_func(:shot, :alien) do |shot_shape, alien_shape|
      @dead_shots << shot_shape.object
      alien_shape.object.destroyed! # reconsider
      @dead_aliens << alien_shape.object
    end

    @space.add_collision_func(:ship, :asteroid) do |ship_shape, asteroid_shape|
      next if ship_shape.object.invulnerable?
      @player.destroyed!
      @split_asteroids << asteroid_shape.object
    end

    @space.add_collision_func(:ship, :alien) do |ship_shape, alien_shape|
      next if ship_shape.object.invulnerable?
      @player.destroyed!
      @dead_aliens << alien_shape.object
    end

    @space.add_collision_func(:alien, :asteroid) do |alien_shape, asteroid_shape|
      @dead_aliens << alien_shape.object
      @split_asteroids << asteroid_shape.object
    end

    # Cause like objects to ignore each other, rather than bumping into one another
    @space.add_collision_func(:asteroid, :asteroid, &nil)
    @space.add_collision_func(:shot, :shot, &nil)
    @space.add_collision_func(:ship, :ship, &nil) # for two player? ;)
    @space.add_collision_func(:alien, :alien, &nil)

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

    # SHOTS
    # Some shots die due to collisions (see collision code), some die of "old age"
    @dead_shots += Shot.old_shots
    Shot.cull(@dead_shots)
    @dead_shots.clear
    Shot.wrap_all_to_screen

    # PLAYER
    if @player.destroyed
      @dock.use_ship
      @player.new_ship unless @dock.no_ships?
    else
      # When a force or torque is set on a body, it is cumulative - probably not the behavior we want
      @player.reset_forces

      # Acceleration/deceleration
      @player.apply_damping
      accelerate_control_pressed ? @player.accelerate : @player.accelerate_none

      shoot_control_pressed ? @player.shoot : @player.shoot_none
      hyperspace_control_pressed ? @player.hyperspace : @player.hyperspace_none

      # Turning
      @player.turn_none
      @player.turn_right if turn_right_control_pressed
      @player.turn_left if turn_left_control_pressed

      @player.wrap_to_screen
    end

    # ASTEROIDS
    @split_asteroids.each do |asteroid|
      @asteroids.delete(asteroid)
      @asteroids.concat(asteroid.split(@space))
      @dock.increment_score(asteroid.points)
    end
    @split_asteroids.clear

    @asteroids.each(&:wrap_to_screen)

    # ALIENS
    @dead_aliens.each do |alien|
      @aliens.delete(alien)
      alien.remove_from_space(@space)
      @dock.increment_score(alien.points)
      Alien.stop_sound unless @aliens.any?
    end
    @dead_aliens.clear

    @aliens.each do |alien|
      if alien.reached_endpoint?
        @aliens.delete(alien)
        alien.remove_from_space(@space)
        Alien.stop_sound unless @aliens.any?
      else
        alien.shoot if alien.ready_to_shoot?
        alien.update_flight_path
        alien.wrap_to_screen
      end
    end

    conditionally_play_doop
    conditionally_send_alien

    # See if we need to add more asteroids...
    @level.next! if @level.complete?
  end

  def draw
    Shot.draw_all
    @asteroids.each(&:draw)
    @aliens.each(&:draw)
    @dock.no_ships? ? draw_game_over : @player.draw
    @dock.draw_at(180, 0)
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end

private
  def conditionally_play_doop
    @last_doop_time ||= Gosu.milliseconds
    doop_delay = @asteroids.inject(1) { |s,a| s + a.scale } * 80
    if @last_doop_time + doop_delay < Gosu.milliseconds
      @doop_sound = (@doop_sound == @high_doop) ? @low_doop : @high_doop
      @doop_sound.play
      @last_doop_time = Gosu.milliseconds
    end
  end

  def conditionally_send_alien
    return unless @level.new_alien?

    Alien.new.tap do |alien|
      @aliens << alien
      alien.add_to_space(@space)
    end
    @level.alien_added!
    Alien.start_sound
  end

  def draw_game_over
    font = Gosu::Font.new(70, name: "media/Hyperspace.ttf")
    middle = 0.5
    center = 0.5
    font.draw_rel("GAME OVER", WIDTH/2, HEIGHT/2, ZOrder::UI, middle, center)
  end

  # CONTROLS
  def accelerate_control_pressed
    Gosu::button_down?(Gosu::KbUp)
  end
  def turn_right_control_pressed
    Gosu::button_down?(Gosu::KbRight) && !Gosu::button_down?(Gosu::KbLeft)
  end
  def turn_left_control_pressed
    Gosu::button_down?(Gosu::KbLeft) && !Gosu::button_down?(Gosu::KbRight)
  end
  def shoot_control_pressed
    Gosu::button_down?(Gosu::KbSpace)
  end
  def hyperspace_control_pressed
    Gosu::button_down?(Gosu::KbLeftShift) || Gosu::button_down?(Gosu::KbRightShift)
  end
end
