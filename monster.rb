class Monster < Entity
	attr_accessor :life

	def initialize(x, y, level)
		@x = x
		@y = y
		@life = initial_life * 1.1**level
	end

	def color
		if @life.to_f / initial_life > 0.8
			Curses::COLOR_GREEN
		elsif @life.to_f / initial_life > 0.3
			Curses::COLOR_YELLOW
		else
			Curses::COLOR_RED
		end
	end

	def take_damage(damage)
		@life -= damage
	end
end
	
class Grunt < Monster
	def char
		'G'
	end

	def speed
		0.3
	end

	def initial_life
		2.0
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

class Camper < Monster
	def char
		'C'
	end

	def speed
		0.1
	end

	def initial_life
		1.0
	end

	def move_towards(target)
		@last = :up unless @last

		directions = {
			:up => [0, -1, :left],
			:left => [-1, 0, :down],
			:down => [0, 1, :right],
			:right => [1, 0, :up]
		}

		new_dir = directions[@last]
		@x += new_dir[0]
		@y += new_dir[1]
		@last = new_dir[2]
	end
end

class Tank < Monster
	def char
		'T'
	end

	def speed
		0.7
	end

	def initial_life
		5.0
	end

	def move_towards(target)
		if target.y > @y
			return @y = @y + 1
		elsif target.y < @y
			return @y = @y - 1
		end

		if target.x > @x
			return @x = @x + 1
		elsif target.x < @x
			return @x = @x - 1
		end
	end
end

MONSTERS = [
	Grunt,
	Camper,
	Tank
]
