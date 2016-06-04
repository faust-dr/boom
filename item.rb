class Item < Entity
	def initialize(x, y, weapon)
		@x = x
		@y = y
		@weapon = weapon
	end

	def char
		@weapon.char
	end

	def color
		@weapon.color
	end

	def effect(player)
		player.weapon = @weapon
	end
end
