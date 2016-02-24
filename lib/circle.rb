class Circle
  attr_reader :columns, :rows
  
  def initialize radius
    @columns = @rows = radius * 2
    lower_half = (0...radius).map do |y|
      x = Math.sqrt(radius**2 - y**2).round
      right_half = "#{155.chr * x}#{"#{0.chr}" * (radius - x)}"
      "#{right_half.reverse}#{right_half}"
    end.join
    @blob = lower_half.reverse + lower_half
    @blob.gsub!(/./) { |alpha| "#{255.chr}#{0.chr}#{255.chr}#{alpha}"}
  end
  
  def to_blob
    @blob
  end
end
