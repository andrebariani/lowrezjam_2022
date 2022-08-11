extends State

export var player_near_radius = 36

onready var player: Player
var dist_to_player
var rng = RandomNumberGenerator.new()

func begin():
	player = e.get_player()
	if e.stateMachine.state_last != "FlyToPlayer":
		e.play_anim("RESET")

func run(_delta):
	if e.is_player_visible():
		dist_to_player = player.global_position - e.global_position
		if abs(dist_to_player.x) < player_near_radius:
			choose_melee_state()
		else:
			choose_ranged_state()
	else:
		e.moving = true
		end("MoveToArea")

func choose_melee_state():
	var p_sign = sign(dist_to_player.x)
	if p_sign == e.ori:
		end("TailSpin")
	else:
		end("TailSpin")
	
func choose_ranged_state():
	if rng.randi_range(0, 10) < 5:
		end("FlyToPlayer")
	else:
		end("AirShoot")
