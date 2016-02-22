module Asteroid
  class Large < Asteroid::Base
    def points
      20
    end

    def chunks
      [Medium.new, Medium.new]
    end

  private
    def self.random_asteroid_image
      @@asteroid_images ||= [
        Gosu::Image.new("media/astlrg1.bmp"),
        Gosu::Image.new("media/astlrg2.bmp"),
        Gosu::Image.new("media/astlrg3.bmp"),
        Gosu::Image.new("media/astlrg4.bmp")
      ]
      @@asteroid_images.sample
    end

    def scale
      4
    end
  end
end
