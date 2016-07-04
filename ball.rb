class Ball < Bullet
	attr_accessor :duration

	def initialize(weapon, x, y, x_dir, y_dir)
		super

		@bounces_left = 1
	end

	def char
		'o'
	end

	def pierce?
		true
	end

	def on_move(_, width, height)
		if on_border?(width, height) && @bounces_left > 0
			@x_dir *= -1
			@y_dir *= -1
			@bounces_left -= 1
		end
	end

	private

	def on_border?(width, height)
		(@x == 0 && @x_dir == -1) || (@y == 0 && @y_dir == -1) || (@x == width-1 && @x_dir == 1) || (@y == height-1 && @y_dir == 1)
	end
end
