class Monster < Entity
	def initialize(x, y, life)
		@x = x
		@y = y
		@speed = 0.2
		@life = life
		@initial_life = life
	end

	def char
		'M'
	end

	def speed
		@speed
	end

	def color
		if @life.to_f / @initial_life > 0.8
			Curses::COLOR_GREEN
		elsif @life.to_f / @initial_life > 0.3
			Curses::COLOR_YELLOW
		else
			Curses::COLOR_RED
		end
	end

	def take_damage(damage)
		@life -= damage
	end
	
	def life
		@life
	end

	def initial_life
		@initial_life
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
