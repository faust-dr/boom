class Monster < Entity
	def initialize(x, y)
		@x = x
		@y = y
		@speed = 0.2
	end

	def char
		'M'
	end

	def speed
		@speed
	end

	def color
		Curses::COLOR_RED
	end

	def move_towards(target)
		if target.x > @x
			@x = @x + 1
		elsif target.x < @x
			@x = @x - 1
		end

		if target.y > @y
			@y = @y + 1
		elsif target.y < @y
			@y = @y - 1
		end
	end
end
