#!/usr/bin/env ruby

require 'bundler/setup'
require 'gaminator'
require './colors.rb'
require './entity.rb'
require './player.rb'
require './monster.rb'
require './bullet.rb'
require './rocket.rb'
require './explosion.rb'
require './light.rb'
require './ball.rb'
require './arrow.rb'
require './item.rb'
require './weapon.rb'
require './bonus.rb'
require './game.rb'

level = ARGV.first.to_i
Gaminator::Runner.new(Game.level(level), :rows => 30, :cols => 80).run
