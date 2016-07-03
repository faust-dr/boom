class Arrow < Bullet
	attr_accessor :duration

	def char
		if @x_dir == 0 && @y_dir > 0
			'v'
		elsif @x_dir == 0 && @y_dir < 0
			'^'
		elsif @y_dir == 0 && @x_dir < 0
			'<'
		else
			'>'
		end
	end

	def on_move(bullets, _, _)
		bullets << projectile.new(self, @x - @x_dir, @y - @y_dir, @y_dir, @x_dir)
		bullets << projectile.new(self, @x - @x_dir, @y - @y_dir, -@y_dir, -@x_dir)
	end

	def projectile
		Bullet
	end

	def effect(monster, bullet, player)
		Pistol.effect(monster, bullet, player)
	end

	def damage
		50
	end
end

class LightArrow < Arrow
	def projectile
		Light
	end

	def effect(monster, bullet, player)
		Laser.effect(monster, bullet, player)
	end
end

class BallArrow < Arrow
	def projectile
		Ball
	end

	def effect(monster, bullet, player)
		Cannon.effect(monster, bullet, player)
	end
end

class RocketArrow < Arrow
	def self.with(bullets)
		@@bullets = bullets
		self
	end

	def projectile
		Rocket
	end

	def effect(monster, bullet, player)
		RocketLauncher.with(@@bullets).effect(monster, bullet, player)
	end
end
