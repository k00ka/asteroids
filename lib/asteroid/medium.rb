module Asteroid
  class Medium < Asteroid::Base
    def points
      50
    end

    def chunks
      [Small.new, Small.new]
    end

  private
    def self.random_asteroid_image
      @@asteroid_images ||= [
        Gosu::Image.new("media/astmed1.bmp"),
        Gosu::Image.new("media/astmed2.bmp"),
        Gosu::Image.new("media/astmed3.bmp"),
        Gosu::Image.new("media/astmed4.bmp")
      ]
      @@asteroid_images.sample
    end

    def scale
      2
    end
  end
end
