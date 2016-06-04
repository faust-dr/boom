class Explosion < Bullet
	attr_accessor :duration

	def initialize(x, y)
		@x = x
		@y = y
		@x_dir = 0
		@y_dir = 0
		@duration = initial_duration
	end

	def char
		@duration.odd? ? '^' : 'v'
	end

	def initial_duration
		1 * FPS
	end

	def damage
		5
	end
end
