class Level
  attr_reader :asteroids

  def initialize(space, asteroids)
    @space = space
    @asteroids = asteroids
  end

  def complete?
    @asteroids.empty?
  end

  def next!
    new_asteroids.times do
      shape = Asteroid.cp_shape
      @space.add_body(shape.body)
      @space.add_shape(shape)

      @asteroids << Asteroid.new(shape)
    end
  end

  private

  def new_asteroids
    4
  end
end
