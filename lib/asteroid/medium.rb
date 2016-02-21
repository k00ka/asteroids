module Asteroid
  class Medium < Asteroid::Base
    attr_reader :image, :body, :shape

    @@images = [Gosu::Image.new("media/astsml1.bmp"), Gosu::Image.new("media/astsml2.bmp")]

    def points
      50
    end

    def chunks
      [Small.new, Small.new]
    end

    private

    def default_image
      @@images.sample
    end
  end
end
