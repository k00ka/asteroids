require "medium_asteroid"

RSpec.describe MediumAsteroid do
  describe ".new" do
    it { is_expected.to be_an_instance_of MediumAsteroid }

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
  end

  describe "#points" do
    it "is worth 50 points" do
      expect(subject.points).to be 50
    end
  end

  describe "chunks" do
    it "breaks into 2 additional asteroids" do
      expect(subject.chunks.length).to be 2
    end
  end
end
