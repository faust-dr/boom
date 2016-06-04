class Entity
	attr_accessor :x, :y

	def initialize(x, y)
		@x = x
		@y = y
	end

	def char
		'?'
	end

	def color
		Curses::COLOR_WHITE
	end
end
