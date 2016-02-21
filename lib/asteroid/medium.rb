module Asteroid
  class Medium < Asteroid::Base
    attr_reader :image, :body, :shape

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
