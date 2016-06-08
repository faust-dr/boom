class Player < Entity
	attr_accessor :weapon, :last_shot_frames, :damage_bonus

	def initialize(x, y)
		@x = x
		@y = y
		@weapon = WEAPONS.first
		@last_shot_frames = 0
		@damage_bonus = 0
	end

	def char
		'@'
	end

	def color
		100 + @last_shot_frames
	end

	def damage
		@weapon.damage + @damage_bonus
	end
end
