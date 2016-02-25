# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

require_relative 'asteroid/base'
require_relative 'asteroid/large'

class Level
  def initialize
  end

  def complete?
  end

  def next!
  end

private

  def asteroid_count
    [2 + (@round * 2), 11].min
  end
end
