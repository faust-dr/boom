#!/usr/bin/env ruby

require 'bundler/setup'
require 'gaminator'
require './colors.rb'
require './entity.rb'
require './player.rb'
require './monster.rb'
require './bullet.rb'
require './game.rb'

Gaminator::Runner.new(Game, :rows => 30, :cols => 80).run
