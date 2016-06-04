class Weapon
	class << self
		def color
			Curses::COLOR_CYAN
		end

		def with(array)
			@bullets = array
			self
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
			2
		end
	end
end

WEAPONS = [
	Pistol,
	Shotgun,
	MachineGun,
	ChainGun
]
