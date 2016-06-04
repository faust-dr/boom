class Weapon < Entity
	def char
		'w'
	end

	def color
		Curses::COLOR_CYAN
	end

	def effect(player)
		player.ammunition += 5
	end
end
