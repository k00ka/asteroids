WIDTH = 800
HEIGHT = 600

FakeBody = Struct.new :p, :v, :a
FakeShape = Struct.new :body, :object

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
        let(:shape) { double("asteroid shape", :body => FakeBody.new, :object= => nil) }
        let!(:subject) do
          described_class.new(shape: shape)
        end

        it "is in the window" do
          expect(shape.body.p.x).to satisfy("x within window width") { |x| x >= 0 && x <= WIDTH }
          expect(shape.body.p.y).to satisfy("x within window width") { |y| y >= 0 && y <= HEIGHT }
        end

        it "has default velocity" do
          expect(shape.body.v.x).to eql 5.0
          expect(shape.body.v.y).to eql 5.0
        end

        it "faces upwards" do
          expect(shape.body.a).to be_within(0.1).of 3 * Math::PI / 2.0
        end
      end
    end

    context "with a shape" do
      let(:shape) { FakeShape.new(double.as_null_object) }
      let!(:subject) { described_class.new(shape: shape) }

      it "associates itself with its shape" do
        expect(subject.shape.object).to be subject
      end
    end
  end
end
