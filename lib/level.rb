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
      asteroid = Asteroid::Large.new

      @space.add_body(asteroid.body)
      @space.add_shape(asteroid.shape)

      @asteroids << asteroid
    end
  end

  private

  def new_asteroids
    4
  end
end
