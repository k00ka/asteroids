require_relative 'small'

module Asteroid
  class Medium < Asteroid::Base
    def points
      50
    end

    def chunks
      [Small.new(position), Small.new(position)]
    end

  private
    def scale
      2
    end
  end
end
