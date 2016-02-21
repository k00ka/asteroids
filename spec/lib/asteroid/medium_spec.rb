require "support/shared_examples/an_initialized_asteroid"

require "asteroid/base"
require "asteroid/small"
require "asteroid/medium"

RSpec.describe Asteroid::Medium do
  it_behaves_like "an initialized asteroid"
  it_behaves_like "it moves on the boundary of a ball" do
    let(:update_position) { subject.update }
  end

  describe "#points" do
    it "is worth 50 points" do
      expect(subject.points).to be 50
    end
  end

  describe "chunks" do
    it "breaks into 2 Small asteroids" do
      chunks = subject.chunks
      expect(chunks.length).to be 2
      chunks.each { |c| expect(c).to be_an_instance_of Asteroid::Small }
    end
  end
end
