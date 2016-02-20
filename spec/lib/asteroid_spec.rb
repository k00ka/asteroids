require "asteroid"
require "gosu"
require "chipmunk"

WIDTH = 800
HEIGHT = 600

FakeBody = Struct.new :p, :v, :a

RSpec.describe Asteroid do
  describe ".new" do
    it "is created" do
      expect(described_class.new(double.as_null_object)).to be_an_instance_of described_class
    end

    context "when initialized" do
      let(:shape)    { double("asteroid shape", :body => FakeBody.new, :object= => nil) }
      let!(:subject) { described_class.new(shape) }

      it "body is assigned a position" do
        expect(shape.body.p.x).to satisfy("x within window width") { |x| x >= 0 && x <= WIDTH }
        expect(shape.body.p.y).to satisfy("x within window width") { |y| y >= 0 && y <= HEIGHT }
      end

      it "body has a default velocity" do
        expect(shape.body.v.x).to eql 5.0
        expect(shape.body.v.y).to eql 5.0
      end

      it "body faces upwards" do
        expect(shape.body.a).to be_within(0.1).of 3 * Math::PI / 2.0
      end
    end
  end

  describe ".random_large_asteroid_image" do
    it "returns an image" do
      expect(described_class.random_large_asteroid_image).to be_an_instance_of Gosu::Image
    end
  end

  describe "#score" do
    subject { described_class.new(double.as_null_object) }
    it "has a score of 10" do
      expect(subject.score).to be 10
    end
  end

  describe "#chunks" do
    context "small asteroids" do
      subject { described_class.new(double.as_null_object, 0) }

      it "returns empty" do
        expect(subject.chunks).to be_empty
      end
    end

    context "large asteroids" do
      subject { described_class.new(double.as_null_object, 2) }

      it "returns 2 asteroids" do
        expect(subject.chunks.length).to be 2
        subject.chunks.each do |obj|
          expect(obj).to be_an_instance_of described_class
        end
      end

      describe "medium asteroids" do
        it "have one less chunk levels than large" do
          expect(subject.chunks.first.chunk).to eql 1
        end
      end
    end
  end
end
