# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

require_relative 'body'

class Shot < Body
  @@image = Gosu::Image.new("media/shot.bmp")
  @@sound = Gosu::Sample.new("media/shot.wav")
  @@speed = 600.0
  @@old_age = 50
  @@shots = []

  attr_reader :shooter

  # current player position and angle
  def initialize(position, angle, shooter)
    super default_shape

    self.position = position
    self.velocity = self.class.calc_velocity(angle, @@speed)
    @shooter = shooter
    @age = 0

    @@sound.play
  end

  def self.wrap_all_to_screen
    @@shots.each(&:wrap_to_screen)
  end

  def self.shoot(position, angle, shooter)
    shot = new(position, angle, shooter)
    @@shots << shot
    shot.add_to_space(@@space)
  end

  def self.shots_taken(shooter)
    @@shots.count { |s| s.shooter == shooter }
  end

  def self.cull(shots)
    shots.each do |shot|
      @@shots.delete(shot)
      shot.remove_from_space(@@space)
    end
  end

  def self.old_shots
    @@shots.select { |s| s.old? }
  end

  def old?
    @age > @@old_age
  end

  def self.draw_all
    @@shots.each(&:draw)
  end

  def draw
    @age += 1
    @@image.draw(self.position.x - 0.5, self.position.y - 0.5, ZOrder::Shots)
  end

  def self.space=(space)
    @@space = space
  end

private
  def default_shape
    shape_array = [CP::Vec2.new(-1.0, -1.0), CP::Vec2.new(-1.0, 1.0), CP::Vec2.new(1.0, 1.0), CP::Vec2.new(1.0, -1.0)]
    CP::Shape::Poly.new(default_body, shape_array).tap do |s|
      s.collision_type = :shot
      s.object = self
    end
  end
end
