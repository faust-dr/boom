class Explosion < Bullet
	attr_accessor :duration

	def initialize(x, y, x_dir, y_dir)
		super
		@duration = initial_duration
	end

	def char
		@duration.odd? ? '^' : 'v'
	end

	def initial_duration
		1 * FPS
	end

	def damage
		10
	end

	def pierce?
		true
	end

	def speed
		2	
	end
end
