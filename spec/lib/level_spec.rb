# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

require "level"

WIDTH = 800 unless defined? WIDTH
HEIGHT = 600 unless defined? HEIGHT

RSpec.describe Level do
  describe "#complete?" do
    context "with no asteroids remaining" do
      subject { described_class.new }

      it { is_expected.to be_complete }
    end

    context "with asteroids remaining" do
      subject { described_class.new }
      before { Asteroid::Base.space = CP::Space.new;subject.next! }
      it { is_expected.to_not be_complete }
    end
  end
end
