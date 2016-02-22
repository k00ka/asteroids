require_relative 'base'

module Asteroid
  class Small < Asteroid::Base
    def points
      100
    end

    def chunks
      []
    end

  private
    def scale
      1
    end
  end
end
