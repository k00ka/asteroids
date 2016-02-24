# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

WIDTH = 800 unless defined? WIDTH
HEIGHT = 600 unless defined? HEIGHT

RSpec.shared_examples "an initialized asteroid" do
  describe ".new" do
    it { is_expected.to be_an_instance_of described_class }

    it "has an image" do
      expect(subject.image).to be_an_instance_of Gosu::Image
    end

    it "has a shape" do
      expect(subject.shape).to be_a CP::Shape
    end

    it "collides as an asteroid" do
      expect(subject.shape.collision_type).to be :asteroid
    end

    it "associates itself to its shape" do
      expect(subject.shape.object).to be subject
    end

    it "has a body" do
      expect(subject.body).to be_an_instance_of CP::Body
    end

    context "when initialized" do
      describe "body" do
        subject { described_class.new }

        it "is in the window" do
          expect(subject.position.x).to satisfy("x within window width") { |x| x >= 0 && x <= WIDTH }
          expect(subject.position.y).to satisfy("y within window height") { |y| y >= 0 && y <= HEIGHT }
        end

        it "has default velocity" do
          expect(subject.velocity.x).not_to be_nil
          expect(subject.velocity.y).not_to be_nil
        end

        it "faces upwards" do
          expect(subject.angle).to be_within(0.1).of 3 * Math::PI / 2.0
        end
      end
    end

    context "with a shape" do
      subject { described_class.new }

      it "associates itself with its shape" do
        expect(subject.shape.object).to be subject
      end
    end
  end
end
