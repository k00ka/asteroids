require "asteroid"
require "gosu"
require "chipmunk"

WIDTH = 800
HEIGHT = 600

FakeBody = Struct.new :p, :v, :a

RSpec.describe Asteroid do
  describe ".new" do
    it "is created" do
      expect(described_class.new(double, double.as_null_object)).to be_an_instance_of described_class
    end

    context "when initialized" do
      let(:shape)    { double("asteroid shape", body: FakeBody.new) }
      let!(:subject) { described_class.new(double, shape) }

      it "body is assigned a position" do
        expect(shape.body.p.x).to satisfy("x within window width") { |x| x >= 0 && x <= WIDTH }
        expect(shape.body.p.y).to satisfy("x within window width") { |y| y >= 0 && y <= HEIGHT }
      end

      it "body has no velocity" do
        expect(shape.body.v.x).to eql 0.0
        expect(shape.body.v.y).to eql 0.0
      end

      it "faces upwards" do
        expect(shape.body.a).to be_within(0.1).of 3 * Math::PI / 2.0
      end
    end
  end
end
