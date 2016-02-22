class Score
  def initialize
    @score = 0
    @font = Gosu::Font.new(70, name: "media/hyperspace.ttf")
  end

  def increment(points)
    @score += points
  end

  # draw the score leftward from top-right
  def draw_at(right = 200, top = 10)
    @font.draw_rel(@score > 0 ? @score : "00", right, top, ZOrder::UI, 1.0, 0.0)
  end
end
