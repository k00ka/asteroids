require "support/fakes/body"
require "support/shared_examples/it_moves_on_the_boundary_of_a_ball"

require "player"

RSpec.describe Player do
  it_behaves_like "it moves on the boundary of a ball" do
    subject { Player.new(double("shape", body: FakeBody.new)) }

    let(:update_position) { subject.validate_position }
  end
end
