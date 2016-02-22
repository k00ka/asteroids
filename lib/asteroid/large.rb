require_relative 'medium'

module Asteroid
  class Large < Asteroid::Base
    def points
      20
    end

    def chunks
      [Medium.new(body.p), Medium.new(body.p)]
    end

  private
    def scale
      4
    end
  end
end
