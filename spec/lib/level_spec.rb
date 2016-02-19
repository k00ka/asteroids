require "level"

RSpec.describe Level do
  describe "#complete?" do
    context "with no asteroids remaining" do
      subject { described_class.new(double, []) }

      it { is_expected.to be_complete }
    end

    context "with asteroids remaining" do
      subject { described_class.new(double, [double("asteroid")]) }

      it { is_expected.to_not be_complete }
    end
  end

  describe "next!" do
    let(:space) { CP::Space.new }
    subject { described_class.new(space, []) }

    it "adds a new level's worth of asteroids" do
      expect {
        subject.next!
      }.to change {  subject.asteroids.count }
    end
  end
end
