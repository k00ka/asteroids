module Asteroid
  class Medium < Asteroid::Base
    attr_reader :image, :body, :shape

    def points
      50
    end

    def chunks
      [Small.new, Small.new]
    end
  end
end
