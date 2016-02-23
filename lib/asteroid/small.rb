# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

require_relative 'base'

module Asteroid
  class Small < Asteroid::Base
    def points
      100
    end

    def chunks
      []
    end

    def scale
      1
    end
  end
end
