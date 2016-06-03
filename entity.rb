class Entity
	def initialize(x, y)
		@x = x
		@y = y
	end

	def x
		@x
	end

	def y
		@y
	end

	def x=(x)
		@x = x
	end

	def y=(y)
		@y = y
	end

	def char
		'?'
	end

	def color
		Curses::COLOR_WHITE
	end
end
