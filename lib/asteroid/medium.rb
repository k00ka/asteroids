# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

require_relative 'small'

module Asteroid
  class Medium < Asteroid::Base
    def points
      50
    end

    def chunks
      [Small.new(position), Small.new(position)]
    end

    def scale
      2.0
    end
  end
end
