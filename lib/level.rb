# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

require_relative 'asteroid/large'

class Level
  attr_reader :asteroids

  def initialize(space, asteroids)
    @space = space
    @asteroids = asteroids
    @round = 0
  end

  def complete?
    @asteroids.empty?
  end

  def time_between_aliens
    return 999999 if @round < 2
    12000 - Math.sqrt(@round) * 1000
  end

  def next!
    @round += 1
    asteroid_count.times do
      asteroid = Asteroid::Large.new
      asteroid.add_to_space(@space)
      @asteroids << asteroid
    end
  end

private
  def asteroid_count
    [2 + (@round * 2), 11].min
  end
end
