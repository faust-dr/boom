class Monster < Entity
	def initialize(x, y)
		@x = x
		@y = y
		@speed = 0.2
		@life = 3
	end

	def char
		'M'
	end

	def speed
		@speed
	end

	def color
		[Curses::COLOR_RED, Curses::COLOR_YELLOW, Curses::COLOR_GREEN][@life-1]
	end

	def take_damage(damage)
		@life -= damage
	end
	
	def life
		@life
	end

	def move_towards(target)
		if target.x > @x
			return @x = @x + 1
		elsif target.x < @x
			return @x = @x - 1
		end

		if target.y > @y
			return @y = @y + 1
		elsif target.y < @y
			return @y = @y - 1
		end
	end
end
