module Asteroid
  class Small < Asteroid::Base
    def points
      100
    end

    def chunks
      []
    end

  private
    def self.random_asteroid_image
      @@asteroid_images ||=  [
        Gosu::Image.new("media/astsml1.bmp"),
        Gosu::Image.new("media/astsml2.bmp"),
        Gosu::Image.new("media/astsml3.bmp"),
        Gosu::Image.new("media/astsml4.bmp")
      ]
      @@asteroid_images.sample
    end

    def scale
      1
    end
  end
end
