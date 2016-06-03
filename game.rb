class Game
	FPS = 30

	def initialize(width, height)
		@width = width
		@height = height
		@player = Player.new(width/2, height/2)
		@bullets = []
		@level = 1
		@monsters = spawn_monsters
		@frame = 1
	end

	def spawn_monsters
		(1..@level).map { create_monster }
	end

	def create_monster
		Monster.new(Random.rand(@width).floor, Random.rand(@height).floor)
	end

	def objects
		[@player] + @bullets + @monsters
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
		}
	end

	def tick
		increase_frame
		move_monsters
		move_bullets
		remove_boundary_bullets
		check_monster_hits
		check_player_hits
		increase_level?
	end

	def increase_frame
		@frame += 1
		if @frame > FPS
			@frame = 0
		end
	end

	def exit_message
		'Exiting..'
	end

	def textbox_content
		"Level: #{@level} | Frame: #{@frame}"
	end

	def wait?
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

	def shoot_left
		@bullets << Bullet.new(@player.x, @player.y, -1, 0)
	end

	def shoot_right
		@bullets << Bullet.new(@player.x, @player.y, 1, 0)
	end

	def shoot_up
		@bullets << Bullet.new(@player.x, @player.y, 0, -1)
	end

	def shoot_down
		@bullets << Bullet.new(@player.x, @player.y, 0, 1)
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
		@bullets.reject! do |bullet|
			@monsters.any? do |monster|
				monster.x == bullet.x && monster.y == bullet.y && @monsters -= [monster]
			end
		end
	end

	def check_player_hits
		if @monsters.any? { |monster| monster.x == @player.x && monster.y == @player.y }
			exit
		end
	end

	def increase_level?
		if @monsters.length == 0
			@level += 1
			@monsters = spawn_monsters
		end
	end
end
