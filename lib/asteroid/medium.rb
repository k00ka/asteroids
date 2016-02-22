require_relative 'small'

module Asteroid
  class Medium < Asteroid::Base
    def points
      50
    end

    def chunks
      [Small.new(body.p), Small.new(body.p)]
    end

  private
    def scale
      2
    end
  end
end
