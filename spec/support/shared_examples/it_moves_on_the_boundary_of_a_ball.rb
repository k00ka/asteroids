# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016

WIDTH = 800 unless defined? WIDTH
HEIGHT = 600 unless defined? HEIGHT

RSpec.shared_examples "it moves on the boundary of a ball" do
  it "wraps around the horizontal direction" do
    x = subject.body.p.x
    y = subject.body.p.y

    subject.body.p = CP::Vec2.new(x + WIDTH, y)

    update_position

    expect(subject.body.p.x).to be_within(0.1).of x
    expect(subject.body.p.y).to be_within(0.1).of y
  end

  it "wraps around the vertical direction" do
    x = subject.body.p.x
    y = subject.body.p.y

    subject.body.p = CP::Vec2.new(x, y + HEIGHT)

    update_position

    expect(subject.body.p.x).to be_within(0.1).of x
    expect(subject.body.p.y).to be_within(0.1).of y
  end
end
