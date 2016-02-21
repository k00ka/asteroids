module Asteroid
  class Large < Asteroid::Base
    attr_reader :image, :shape, :body

    @@images = [Gosu::Image.new("media/astsml1.bmp"), Gosu::Image.new("media/astsml2.bmp")]

    def points
      20
    end

    def chunks
      [Medium.new, Medium.new]
    end

    private

    def default_image
      @@images.sample
    end
  end
end
