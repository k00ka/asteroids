# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

require_relative 'medium'

module Asteroid
  class Large < Asteroid::Base
    def points
      20
    end

    def chunks
      [Medium.new(position), Medium.new(position)]
    end

    def scale
      4.0
    end
  end
end
