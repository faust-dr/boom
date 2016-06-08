class Weapon
	class << self
		def color
			Curses::COLOR_CYAN
		end

		def with(array)
			@bullets = array
			self
		end

		def effect(monster, bullet, player)
			monster.take_damage(damage + player.damage_bonus)
		end
	end
end

class Pistol < Weapon
	class << self
		def char
			'p'
		end

		def shoot(x, y, x_dir, y_dir)
			@bullets << Bullet.new(x, y, x_dir, y_dir)
		end

		def rate
			0.5	
		end

		def damage
			1
		end
	end
end

class Shotgun < Weapon
	class << self
		def char
			's'
		end

		def shoot(x, y, x_dir, y_dir)
			@bullets << Bullet.new(x, y, x_dir, y_dir)
			@bullets << Bullet.new(x + y_dir, y + x_dir, x_dir, y_dir)
			@bullets << Bullet.new(x - y_dir, y - x_dir, x_dir, y_dir)
		end

		def rate
			1
		end

		def damage
			3
		end
	end
end

class MachineGun < Weapon
	class << self
		def char
			'm'
		end

		def shoot(x, y, x_dir, y_dir)
			@bullets << Bullet.new(x, y, x_dir, y_dir)
		end

		def rate
			0.2
		end

		def damage
			1
		end
	end
end

class AutoShotgun < Weapon
	class << self
		def char
			'a'
		end

		def magazine_size
			5
		end

		def shoot(x, y, x_dir, y_dir)
			@shots_left = magazine_size unless @shots_left

			if @shots_left <= 0
				@shots_left = magazine_size
			end

			@bullets << Bullet.new(x, y, x_dir, y_dir)
			@bullets << Bullet.new(x + y_dir, y + x_dir, x_dir, y_dir)
			@bullets << Bullet.new(x - y_dir, y - x_dir, x_dir, y_dir)

			@shots_left -= 1
		end

		def rate
			@shots_left = magazine_size unless @shots_left

			if @shots_left == (magazine_size - 1)
				1
			else
				0.1
			end
		end

		def damage
			4
		end
	end
end

class ChainGun < Weapon
	class << self
		def char
			'c'
		end

		def shoot(x, y, x_dir, y_dir)
			@last = 0 unless @last
			@last = 0 if @last >= 3

			if @last == 0
				@bullets << Bullet.new(x, y, x_dir, y_dir)
			elsif @last == 1
				@bullets << Bullet.new(x + y_dir, y + x_dir, x_dir, y_dir)
			else
				@bullets << Bullet.new(x - y_dir, y - x_dir, x_dir, y_dir)
			end

			@last += 1
		end

		def rate
			0.1
		end

		def damage
			8
		end
	end
end

class RocketLauncher < Weapon
	class << self
		def char
			'r'
		end

		def shoot(x, y, x_dir, y_dir)
			@bullets << Rocket.new(x, y, x_dir, y_dir)
		end

		def rate
			1.3
		end

		def damage
			40
		end

		def effect(monster, bullet)
			monster.take_damage(damage)
			x = monster.x
			y = monster.y
			x_dir = bullet.x_dir
			y_dir = bullet.y_dir

			return if @bullets.nil?

			(-2..2).each do |i|
				(-2..2).each do |j|
					@bullets << Explosion.new(x + i, y + j, x_dir, y_dir)
				end
			end

			@bullets << Explosion.new(x + 3, y, x_dir, y_dir)
			@bullets << Explosion.new(x - 3, y, x_dir, y_dir)
			@bullets << Explosion.new(x, y + 3, x_dir, y_dir)
			@bullets << Explosion.new(x, y - 3, x_dir, y_dir)
		end
	end
end

class Laser < Weapon
	class << self
		def char
			'l'
		end

		def shoot(x, y, x_dir, y_dir)
			@bullets << Light.new(x, y, x_dir, y_dir)
		end

		def rate
			0.3
		end

		def damage
			20
		end
	end
end

WEAPONS = [
	Pistol,
	Shotgun,
	MachineGun,
	AutoShotgun,
	ChainGun,
	RocketLauncher,
	Laser
]
