# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

require "player"

WIDTH = 800 unless defined? WIDTH
HEIGHT = 600 unless defined? HEIGHT

RSpec.describe Player do
  describe "#invulnerable?" do
    context "when new" do
      let!(:subject) { described_class.new(double("dt")) }

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
