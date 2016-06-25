class Ball < Bullet
	attr_accessor :duration

	def char
		'o'
	end

	def pierce?
		true
	end
end
