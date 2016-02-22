require "support/shared_examples/an_initialized_asteroid"
require "support/shared_examples/it_moves_on_the_boundary_of_a_ball"

require "asteroid/large"

RSpec.describe Asteroid::Large do
  it_behaves_like "an initialized asteroid"
  it_behaves_like "it moves on the boundary of a ball" do
    let(:update_position) { subject.update }
  end

  describe "#points" do
    it "is worth 20 points" do
      expect(subject.points).to be 20
    end
  end

  describe "chunks" do
    it "breaks into 2 Medium asteroids" do
      chunks = subject.chunks

      expect(chunks.length).to be 2
      chunks.each do |chunk|
        expect(chunk).to be_an_instance_of Asteroid::Medium
      end
    end
  end
end
