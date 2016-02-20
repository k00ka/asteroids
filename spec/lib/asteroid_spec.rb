require "asteroid"
require "gosu"
require "chipmunk"

WIDTH = 800
HEIGHT = 600

FakeBody = Struct.new :p, :v, :a

RSpec.describe Asteroid do
  describe ".new" do
    it "is created" do
<<<<<<< HEAD
      expect(described_class.new(double, double.as_null_object)).to be_an_instance_of described_class
=======
      expect(described_class.new(double.as_null_object)).to be_an_instance_of described_class
>>>>>>> 89f744053dc8ab39f6394ed20869f548fc17d4cc
    end

    context "when initialized" do
      let(:shape)    { double("asteroid shape", :body => FakeBody.new, :object= => nil) }
<<<<<<< HEAD
      let!(:subject) { described_class.new(double, shape) }
=======
      let!(:subject) { described_class.new(shape) }
>>>>>>> 89f744053dc8ab39f6394ed20869f548fc17d4cc

      it "body is assigned a position" do
        expect(shape.body.p.x).to satisfy("x within window width") { |x| x >= 0 && x <= WIDTH }
        expect(shape.body.p.y).to satisfy("x within window width") { |y| y >= 0 && y <= HEIGHT }
      end

      it "body has no velocity" do
        expect(shape.body.v.x).to eql 0.0
        expect(shape.body.v.y).to eql 0.0
      end

      it "body faces upwards" do
        expect(shape.body.a).to be_within(0.1).of 3 * Math::PI / 2.0
      end
    end
  end

<<<<<<< HEAD
  describe "#score" do
    subject { described_class.new(double, double.as_null_object) }
=======
  describe ".default_animation" do
    it "returns an animation" do
      expect(described_class.default_animation).to be_an_instance_of Array
      described_class.default_animation.each do |img|
        expect(img).to be_an_instance_of Gosu::Image
      end
    end
  end

  describe ".default_animation=" do
    it "changes the default animation" do
      animation = double("animation")
      described_class.default_animation = animation

      expect(described_class.default_animation).to be animation
    end
  end

  describe "#score" do
    subject { described_class.new(double.as_null_object) }
>>>>>>> 89f744053dc8ab39f6394ed20869f548fc17d4cc
    it "has a score of 10" do
      expect(subject.score).to be 10
    end
  end

  describe "#spawns" do
    context "with no remaining spawns" do
<<<<<<< HEAD
      subject { described_class.new(double, double.as_null_object, 0) }
=======
      subject { described_class.new(double.as_null_object, 0) }
>>>>>>> 89f744053dc8ab39f6394ed20869f548fc17d4cc

      it "returns empty" do
        expect(subject.spawns).to be_empty
      end
    end

    context "with 2 spawns remaining" do
<<<<<<< HEAD
      subject { described_class.new(double, double.as_null_object, 2) }
=======
      subject { described_class.new(double.as_null_object, 2) }
>>>>>>> 89f744053dc8ab39f6394ed20869f548fc17d4cc

      it "returns 2 asteroids" do
        expect(subject.spawns.length).to be 2
        subject.spawns.each do |obj|
          expect(obj).to be_an_instance_of described_class
        end
      end

      describe "the spawned asteroids" do
        it "have one less spawn than parent" do
          expect(subject.spawns.first.spawn).to eql 1
        end
      end
    end
  end
end
