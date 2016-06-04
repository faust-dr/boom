class Player < Entity
	attr_accessor :weapon

	def initialize(x, y)
		@x = x
		@y = y
		@weapon = WEAPONS.first
	end

	def char
		'@'
	end
end
