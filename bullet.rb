class Bullet < Entity
	def initialize(x, y, x_dir, y_dir)
		@x = x
		@y = y
		@x_dir = x_dir
		@y_dir = y_dir
	end

	def color
		Curses::COLOR_YELLOW
	end
	
	def x_dir
		@x_dir
	end
	
	def y_dir
		@y_dir
	end

	def char
		'.'
	end
end
