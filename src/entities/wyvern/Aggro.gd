extends State

export var player_near_radius = 16

onready var player: Player

func begin():
	player = e.get_player()

func run(_delta):
	if e.is_player_visible():
		var dist = abs(player.global_position.x - e.global_position.x)
		print_debug(dist)
		if dist < player_near_radius:
			choose_melee_state()
		else:
			choose_ranged_state()
	else:
		end("Sleep")

func choose_melee_state():
	end("Bite")
	
func choose_ranged_state():
	end("WalkToPlayer")
