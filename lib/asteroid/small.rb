module Asteroid
  class Small < Asteroid::Base
    attr_reader :image, :body, :shape

    def points
      100
    end

    def chunks
      []
    end
  end
end
