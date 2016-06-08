class Monster < Entity
	attr_accessor :life

	def initialize(x, y, level, player)
		@x = x
		@y = y
		@level = level
		@life = initial_life
		@player = player
	end

	def same_plane_as_player?
		@x == @player.x || @y == @player.y
	end

	def color
		pos = ((1 - life_fraction) * LIFE.size).round
		LIFE[pos] || 88
	end

	def take_damage(damage)
		@life -= damage
	end

	def initial_life
		base_life * 1.1**@level
	end

	def life_fraction
		@life.to_f / initial_life
	end

	def shots_left
		shots_left = (@life.to_f / @player.damage).ceil
		(shots_left > 9 ? '+' : shots_left).to_s
	end

	def char
		same_plane_as_player? ? shots_left : original_char
	end
end
	
class Grunt < Monster
	def original_char
		'G'
	end

	def speed
		0.3
	end

	def base_life
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
	def original_char
		'C'
	end

	def speed
		0.1
	end

	def base_life
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
	def original_char
		'T'
	end

	def speed
		0.7
	end

	def base_life
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
