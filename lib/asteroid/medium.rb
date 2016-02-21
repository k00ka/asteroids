module Asteroid
  class Medium < Asteroid::Base
    def points
      50
    end

    def chunks
      [Small.new, Small.new]
    end

    private

    def scale
      2
    end
  end
end
