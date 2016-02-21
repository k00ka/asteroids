module Asteroid
  class Small < Asteroid::Base
    attr_reader :image, :body, :shape

    @@images = [Gosu::Image.new("media/astsml1.bmp"), Gosu::Image.new("media/astsml2.bmp")]

    def points
      100
    end

    def chunks
      []
    end

    private

    def default_image
      @@images.sample
    end
  end
end
