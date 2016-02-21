module Asteroid
  class Large < Asteroid::Base
    def points
      20
    end

    def chunks
      [Medium.new, Medium.new]
    end

    private

    def scale
      4
    end
  end
end
