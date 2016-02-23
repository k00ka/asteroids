#Encoding: UTF-8

require_relative 'asteroid/large'

class Level
  attr_reader :asteroids

  def initialize(space, asteroids)
    @space = space
    @asteroids = asteroids
    @round = 1
  end

  def complete?
    @asteroids.empty?
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
    4 * @round
  end
end
