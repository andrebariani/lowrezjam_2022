extends State

onready var player: Player
var last_player_pos = Vector2.ZERO

func begin():
	player = e.get_player()
	last_player_pos = player.global_position
	
	e.align_to_target(last_player_pos)

func run(_delta):
	e.move_to(last_player_pos)
	
	if e.position.distance_to(last_player_pos) < 16:
		end("Aggro")
