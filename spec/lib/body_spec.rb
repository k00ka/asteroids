require "support/fakes/shape"
require "support/fakes/body"
require "support/shared_examples/it_moves_on_the_boundary_of_a_ball"

require "body"

describe Body do
  it_behaves_like "it moves on the boundary of a ball" do
    let(:position) { CP::Vec2.new(0.0, 0.0) }
    let(:body)     { FakeBody.new(position) }
    let(:shape)    { FakeShape.new(body) }

    subject { described_class.new(shape) }

    let(:update_position) { subject.wrap_to_screen }
  end
end
