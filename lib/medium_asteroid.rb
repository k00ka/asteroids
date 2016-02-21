class MediumAsteroid < Asteroid
  attr_reader :image, :body

  @@images = [Gosu::Image.new("media/astsml1.bmp"), Gosu::Image.new("media/astsml2.bmp")]

  def initialize
    @image = default_image
    @body = CP::Body.new(0.0001, 0.0001)
    @shape = CP::Shape::Circle.new(@body, 25/2, CP::Vec2.new(0.0, 0.0)).tap do |s|
      s.collision_type = :asteroid
      s.object = self
    end
  end

  def points
    50
  end

  def chunks
    [LargeAsteroid.new, LargeAsteroid.new]
  end

  private

  def default_image
    @@images.sample
  end
end
