# Encoding: UTF-8

# Ruby Hack Night Asteroids by David Andrews and Jason Schweier, 2016
# Contact the authors at david (at) ryatta.com and jason.schweier (at) gmail.com
# Based loosely on ChipmunkIntegration.rb by Dirk Johnson, MIT license

require 'rubygems'
require 'byebug'
require 'gosu'
require 'chipmunk'
require_relative 'lib/game'

WIDTH = 1000
HEIGHT = 650

Game.new.show
