class Bullet < Entity
	attr_accessor :x_dir, :y_dir, :frames_until_next_move, :weapon

	def initialize(weapon, x, y, x_dir, y_dir)
		@weapon = weapon
		@x = x
		@y = y
		@x_dir = x_dir
		@y_dir = y_dir
		@frames_until_next_move = 0
	end

	def color
		Curses::COLOR_YELLOW
	end
	
	def char
		'.'
	end

	def pierce?
		false
	end

	def speed
		1
	end

	def on_move(bullets, _, _)
	end
end
