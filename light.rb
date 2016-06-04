class Light < Bullet
	attr_accessor :duration

	def char
		@x_dir == 0 ? '|' : '-'
	end

	def damage
		10
	end

	def pierce?
		true
	end
end
