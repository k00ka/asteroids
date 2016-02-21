require "support/shared_examples/an_initialized_asteroid"

require "asteroid/base"
require "asteroid/small"

RSpec.describe Asteroid::Small do
  it_behaves_like "an initialized asteroid"
  it_behaves_like "it moves on the boundary of a ball" do
    let(:update_position) { subject.update }
  end

  describe "#points" do
    it "is worth 100 points" do
      expect(subject.points).to be 100
    end
  end

  describe "chunks" do
    it "breaks into no additional chunks" do
      expect(subject.chunks).to be_empty
    end
  end
end
