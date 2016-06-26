class Bonus < Item
	def initialize(x, y)
		@x = x
		@y = y
	end

	def char
		'*'
	end

	def color
		Curses::COLOR_YELLOW
	end

	def effect(player)
		player.damage_bonus += 2
	end
end
