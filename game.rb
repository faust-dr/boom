FPS = 30

class Game
	def initialize(width, height)
		@width = width
		@height = height
		@player = Player.new(width/2, height/2)
		@bullets = []
		@level = 1
		@frame = 1
		@kill_counter = 0
		@items = []
		@last_shot_frames = 0
		@paused = false

		spawn_monsters
	end

	def monster_number_factor
		1.3**@level
	end

	def spawn_monsters
		@monsters = (1..monster_number_factor).map { create_monster(@level) }
	end

	def create_monster(level)
		range = [(1 + @level / 5).floor, MONSTERS.length].min
		@range = range
		type = MONSTERS[Random.rand(range)]

		x = Random.rand(@width).floor
		y = Random.rand(@height).floor

		while (x - @player.x).abs < 10 do
			x = Random.rand(@width).floor
		end
		while (y - @player.y).abs < 10 do
			y = Random.rand(@height).floor
		end

		type.new(x, y, level)
	end

	def objects
		[@player] + @bullets + @monsters + @items
	end

	def input_map
		{
			?a => :move_left,
			?t => :move_right,
			?f => :move_up,
			?s => :move_down,

			?n => :shoot_left,
			?i => :shoot_right,
			?u => :shoot_up,
			?e => :shoot_down,

			?q => :exit,
			' '=> :pause,
		}
	end

	def pause
		@paused = !@paused
	end

	def tick
		increment_frame
		move_bullets
		move_monsters
		check_monster_hits
		remove_boundary_bullets
		check_player_hits
		increase_level?
		decrease_explosion_duration
	end

	def increment_frame
		@frame += 1
		if @frame > FPS
			@frame = 0
		end

		if @last_shot_frames > 0
			@last_shot_frames -= 1
		end
	end

	def exit_message
		'Exiting..'
	end

	def textbox_content
		"Level: #{@level} | Killed: #{@kill_counter} | Weapon: #{@player.weapon.to_s} | Range : #{@range} | Objects: #{objects.length}"
	end

	def wait?
		@paused
	end

	def sleep_time
		1.0/FPS
	end

	def move_left
		@player.x = @player.x - 1 unless @player.x == 0
	end

	def move_right
		@player.x = @player.x + 1 unless @player.x == (@width - 1)
	end

	def move_up
		@player.y = @player.y - 1 unless @player.y == 0
	end

	def move_down
		@player.y = @player.y + 1 unless @player.y == (@height - 1)
	end

	def shoot(x_dir, y_dir)
		return unless @last_shot_frames == 0

		@last_shot_frames = FPS.to_f * @player.weapon.rate
		@player.weapon.with(@bullets).shoot(@player.x, @player.y, x_dir, y_dir)
	end

	def shoot_left
		shoot(-1, 0)
	end

	def shoot_right
		shoot(1, 0)
	end

	def shoot_up
		shoot(0, -1)
	end

	def shoot_down
		shoot(0, 1)
	end

	def exit
		Kernel.exit
	end

	private

	def move_monsters
		@monsters.each do |monster|
			if @frame % (monster.speed * FPS.to_f) == 0
				monster.move_towards(@player)
			end
		end
	end

	def move_bullets
		@bullets.each do |bullet|
			bullet.x = bullet.x + bullet.x_dir
			bullet.y = bullet.y + bullet.y_dir
		end
		check_monster_hits
	end

	def remove_boundary_bullets
		@bullets.reject! do |bullet|
			bullet.x < 0 ||
			bullet.y < 0 ||
			bullet.x > (@width - 1) ||
			bullet.y > (@height - 1)
		end
	end

	def check_monster_hits
		@bullets.each do |bullet|
			@monsters.each do |monster|
				if monster.x == bullet.x && monster.y == bullet.y
					if bullet.class == Explosion
						monster.take_damage(bullet.damage)
					else
						@player.weapon.effect(monster)
					end

					if monster.life <= 0
						@monsters.delete(monster)
						@kill_counter += 1
						weapon_drop(monster.x, monster.y)
					end
					@bullets.delete(bullet) unless bullet.pierce?
				end
			end
		end
	end

	def weapon_dropped?
		!@items.empty?
	end

	def ready_for_next_weapon?
		@level/4 > WEAPONS.index(@player.weapon)
	end

	def next_weapon
		WEAPONS[WEAPONS.index(@player.weapon) + 1]
	end

	def weapon_drop(x, y)
		return if weapon_dropped? || !ready_for_next_weapon? || next_weapon.nil?

		@items << Item.new(x, y, next_weapon)
	end

	def check_player_hits
		if @monsters.any? { |monster| monster.x == @player.x && monster.y == @player.y }
			exit
		end

		@items.each do |item|
			if item.x == @player.x && item.y == @player.y
				item.effect(@player)
				@items.delete(item)
			end
		end
	end

	def increase_level?
		if @monsters.length == 0
			@level += 1
			spawn_monsters
		end
	end

	def decrease_explosion_duration
		@bullets.select {|b| b.class == Explosion}.each do |explosion|
			explosion.duration -= 1
			if explosion.duration == 0
				@bullets.delete(explosion)
			end
		end
	end
end
