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

		def single(x, y, x_dir, y_dir)
			@bullets << projectile.new(self, x, y, x_dir, y_dir)
		end

		def shotgun(x, y, x_dir, y_dir)
			@bullets << projectile.new(self, x, y, x_dir, y_dir)
			@bullets << projectile.new(self, x + y_dir, y + x_dir, x_dir, y_dir)
			@bullets << projectile.new(self, x - y_dir, y - x_dir, x_dir, y_dir)
		end

		def chaingun(x, y, x_dir, y_dir)
			@last = 0 unless @last
			@last = 0 if @last >= 3

			if @last == 0
				@bullets << projectile.new(self, x, y, x_dir, y_dir)
			elsif @last == 1
				@bullets << projectile.new(self, x + y_dir, y + x_dir, x_dir, y_dir)
			else
				@bullets << projectile.new(self, x - y_dir, y - x_dir, x_dir, y_dir)
			end

			@last += 1
		end

		def explosion(monster, bullet, player)
			monster.take_damage(damage + player.damage_bonus)
			x = monster.x
			y = monster.y
			x_dir = bullet.x_dir
			y_dir = bullet.y_dir

			return if @bullets.nil?

			(-1..1).each do |i|
				(-1..1).each do |j|
					@bullets << Explosion.new(self, x + i, y + j, x_dir, y_dir)
				end
			end
		end
	end
end

class Pistol < Weapon
	class << self
		def char
			'p'
		end

		def shoot(x, y, x_dir, y_dir)
			single(x, y, x_dir, y_dir)
		end

		def rate
			0.5	
		end

		def damage
			1
		end

		def projectile
			Bullet
		end
	end
end

class Shotgun < Weapon
	class << self
		def char
			's'
		end

		def shoot(x, y, x_dir, y_dir)
			shotgun(x, y, x_dir, y_dir)
		end

		def rate
			1
		end

		def damage
			3
		end

		def projectile
			Bullet
		end
	end
end

class MachineGun < Weapon
	class << self
		def char
			'm'
		end

		def shoot(x, y, x_dir, y_dir)
			single(x, y, x_dir, y_dir)
		end

		def rate
			0.2
		end

		def damage
			1
		end

		def projectile
			Bullet
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

			@bullets << Bullet.new(self, x, y, x_dir, y_dir)
			@bullets << Bullet.new(self, x + y_dir, y + x_dir, x_dir, y_dir)
			@bullets << Bullet.new(self, x - y_dir, y - x_dir, x_dir, y_dir)

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
			chaingun(x, y, x_dir, y_dir)
		end

		def rate
			0.1
		end

		def damage
			10
		end

		def projectile
			Bullet
		end
	end
end

class RocketLauncher < Weapon
	class << self
		def char
			'r'
		end

		def shoot(x, y, x_dir, y_dir)
			single(x, y, x_dir, y_dir)
		end

		def rate
			1.3
		end

		def damage
			40
		end

		def effect(monster, bullet, player)
			monster.take_damage(damage + player.damage_bonus)
			x = monster.x
			y = monster.y
			x_dir = bullet.x_dir
			y_dir = bullet.y_dir

			return if @bullets.nil?

			(-2..2).each do |i|
				(-2..2).each do |j|
					@bullets << Explosion.new(self, x + i, y + j, x_dir, y_dir)
				end
			end

			@bullets << Explosion.new(self, x + 3, y, x_dir, y_dir)
			@bullets << Explosion.new(self, x - 3, y, x_dir, y_dir)
			@bullets << Explosion.new(self, x, y + 3, x_dir, y_dir)
			@bullets << Explosion.new(self, x, y - 3, x_dir, y_dir)
		end

		def projectile
			Rocket
		end
	end
end

class Laser < Weapon
	class << self
		def char
			'l'
		end

		def shoot(x, y, x_dir, y_dir)
			(0..80).each do |i|
				single(x + x_dir * i, y + y_dir * i, x_dir, y_dir)
			end
		end

		def rate
			0.5
		end

		def damage
			20
		end

		def projectile
			Light
		end
	end
end

class QuadShotgun < Weapon
	class << self
		def char
			'q'
		end

		def magazine_size
			20
		end

		def shoot(x, y, x_dir, y_dir)
			@shots_left = magazine_size unless @shots_left

			if @shots_left <= 0
				@shots_left = magazine_size
			end

			@bullets << Bullet.new(self, x, y, x_dir, y_dir)
			@bullets << Bullet.new(self, x + y_dir, y + x_dir, x_dir, y_dir)
			@bullets << Bullet.new(self, x + 2 * y_dir, y + 2 * x_dir, x_dir, y_dir)
			@bullets << Bullet.new(self, x - y_dir, y - x_dir, x_dir, y_dir)
			@bullets << Bullet.new(self, x - 2 * y_dir, y - 2 * x_dir, x_dir, y_dir)

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
			40
		end
	end
end

class RocketMachinegun < Weapon
	class << self
		def char
			'f'
		end

		def shoot(x, y, x_dir, y_dir)
			single(x, y, x_dir, y_dir)
		end

		def rate
			0.2
		end

		def damage
			20
		end

		def effect(monster, bullet, player)
			explosion(monster, bullet, player)
		end

		def projectile
			Rocket
		end
	end
end

class LaserShotgun < Weapon
	class << self
		def char
			'l'
		end

		def shoot(x, y, x_dir, y_dir)
			(0..80).each do |i|
				@bullets << Light.new(self, x + x_dir * i, y + y_dir * i, x_dir, y_dir)
				@bullets << Light.new(self, x + x_dir * i + y_dir, y + y_dir * i + x_dir, x_dir, y_dir)
				@bullets << Light.new(self, x + x_dir * i - y_dir, y + y_dir * i - x_dir, x_dir, y_dir)
			end
		end

		def rate
			1
		end

		def damage
			50
		end
	end
end

class RocketShotgun < Weapon
	class << self
		def char
			'R'
		end

		def shoot(x, y, x_dir, y_dir)
			shotgun(x, y, x_dir, y_dir)
		end

		def rate
			1
		end

		def damage
			50
		end

		def effect(monster, bullet, player)
			explosion(monster, bullet, player)
		end

		def projectile
			Rocket
		end
	end
end

class RocketChaingun < Weapon
	class << self
		def char
			'C'
		end

		def rate
			0.1
		end

		def damage
			75
		end

		def shoot(x, y, x_dir, y_dir)
			chaingun(x, y, x_dir, y_dir)
		end

		def effect(monster, bullet, player)
			explosion(monster, bullet, player)
		end

		def projectile
			Rocket
		end
	end
end

class DoubleLaser < Weapon
	class << self
		def char
			'd'
		end

		def shoot(x, y, x_dir, y_dir)
			@bullets << Light.new(self, x, y, x_dir, y_dir)
			@bullets << Light.new(self, x, y, -x_dir, -y_dir)
		end

		def rate
			0.1
		end

		def damage
			30
		end
	end
end

class Cannon < Weapon
	class << self
		def char
			'c'
		end

		def shoot(x, y, x_dir, y_dir)
			single(x, y, x_dir, y_dir)
		end

		def rate
			0.5
		end

		def damage
			100
		end

		def projectile
			Ball
		end
	end
end

class LaserChaingun < Weapon
	class << self
		def char
			'L'
		end

		def rate
			0.1
		end

		def damage
			75
		end

		def shoot(x, y, x_dir, y_dir)
			chaingun(x, y, x_dir, y_dir)
		end

		def projectile
			Light
		end
	end
end

class CannonShotgun < Weapon
	class << self
		def char
			'C'
		end

		def shoot(x, y, x_dir, y_dir)
			shotgun(x, y, x_dir, y_dir)
		end

		def rate
			0.7
		end

		def damage
			150
		end

		def projectile
			Ball
		end
	end
end

class CannonChaingun < Weapon
	class << self
		def char
			'C'
		end

		def rate
			0.1
		end

		def damage
			150
		end

		def shoot(x, y, x_dir, y_dir)
			chaingun(x, y, x_dir, y_dir)
		end

		def projectile
			Ball
		end
	end
end

class ArrowGun < Weapon
	class << self
		def char
			'a'
		end

		def rate
			1
		end

		def damage
			150
		end

		def shoot(x, y, x_dir, y_dir)
			single(x, y, x_dir, y_dir)
		end

		def projectile
			Arrow
		end

		def effect(monster, bullet, player)
			explosion(monster, bullet, player)
		end
	end
end

class LaserArrowGun < ArrowGun
	class << self
		def char
			'A'
		end

		def projectile
			LightArrow
		end
	end
end

class BallArrowGun < ArrowGun
	class << self
		def char
			'B'
		end

		def projectile
			BallArrow
		end
	end
end

class RocketArrowGun < ArrowGun
	class << self
		def char
			'R'
		end

		def projectile
			RocketArrow.with(@bullets)
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
	ArrowGun,
	Laser,
	QuadShotgun,
	Cannon,
	RocketShotgun,
	LaserShotgun,
	LaserArrowGun,
	RocketMachinegun,
	DoubleLaser,
	CannonShotgun,
	BallArrowGun,
	RocketChaingun,
	LaserChaingun,
	CannonChaingun,
	RocketArrowGun
]
