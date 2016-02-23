# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

require "support/fakes/body"
require "support/fakes/shape"
require "support/shared_examples/it_moves_on_the_boundary_of_a_ball"

require "player"

RSpec.describe Player do
  it_behaves_like "it moves on the boundary of a ball" do
    let(:position) { CP::Vec2.new(400, 300) }
    let(:body) { FakeBody.new(position) }
    let(:shape) { FakeShape.new(body) }
    subject { Player.new(double("shots"), shape) }

    let(:update_position) { subject.validate_position }
  end

  describe "#invulnerable?" do
    context "when new" do
      let!(:subject) { described_class.new(double("shots")) }

      it { is_expected.to be_invulnerable }

      context "with 500ms of invulnerability" do
        before do
          described_class.class_variable_set(:@@invulnerable_time, 500)
        end

        it "is invulnerable before 500ms" do
          advance_time(499)
          expect(subject).to be_invulnerable
        end

        it "is vulnerable on or after 500ms" do
          advance_time(500)
          expect(subject).not_to be_invulnerable
        end
      end
    end
  end
end

def advance_time(ms)
  time = Gosu.milliseconds
  allow(Gosu).to receive(:milliseconds) { time + ms }
end
