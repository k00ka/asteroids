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
      4
    end
  end
end
