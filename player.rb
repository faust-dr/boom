class Player < Entity
	attr_accessor :ammunition

	def initialize(x, y)
		@x = x
		@y = y
		@ammunition = 0
	end

	def char
		'@'
	end
end
