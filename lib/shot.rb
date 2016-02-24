# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

require_relative 'body'

class Shot < Body
  @@image = Gosu::Image.new("media/shot.bmp")
  @@sound = Gosu::Sample.new("media/shot.wav")
  @@speed = 600.0
  @@old_age = 55

  # current player position and angle
  def initialize(position, angle)
    super default_shape

    self.position = position
    self.velocity = self.class.calc_velocity(angle, @@speed)

    @age = 0
    @@sound.play   
  end

  def draw
    @age += 1
    @@image.draw(self.position.x - 0.5, self.position.y - 0.5, ZOrder::Shots)
  end

  def old?
    @age > @@old_age
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
