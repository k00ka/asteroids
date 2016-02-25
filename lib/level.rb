# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

require_relative 'asteroid/base'
require_relative 'asteroid/large'

class Level
  def initialize
    @round = 0
    @last_alien_at = Gosu.milliseconds
  end

  def complete?
    !Asteroid::Base.any?
  end

  def time_for_new_alien?
    @last_alien_at + time_between_aliens < Gosu.milliseconds
  end

  def alien_added!
    @last_alien_at = Gosu.milliseconds
  end

  def next!
    @round += 1
    @last_alien_at = Gosu.milliseconds
    Asteroid::Large.create(asteroid_count)
  end

private

  def time_between_aliens
    return 999999 if @round < 2
    12000 - Math.sqrt(@round) * 1000
  end

  def asteroid_count
    [2 + (@round * 2), 11].min
  end
end
