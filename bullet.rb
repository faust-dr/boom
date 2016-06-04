class Bullet < Entity
	attr_accessor :x_dir, :y_dir

	def initialize(x, y, x_dir, y_dir)
		@x = x
		@y = y
		@x_dir = x_dir
		@y_dir = y_dir
	end

	def color
		Curses::COLOR_YELLOW
	end
	
	def char
		'.'
	end
end
