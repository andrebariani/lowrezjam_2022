extends State

export var player_near_radius = 36

onready var player: Player
var dist_to_player
var rng = RandomNumberGenerator.new()

func begin():
	player = e.get_player()
	if e.stateMachine.state_last != "WalkToPlayer":
		e.play_anim("RESET")
	if e.stateMachine.state_last == "Topple":
		e.moving = false

func run(_delta):
	if e.moving:
		if e.can_sleep and not e.is_player_visible():
			end("Sleep")
			return
		e.moving = false
		end("AwaitPlayer")
	elif e.is_player_visible():
		dist_to_player = player.global_position - e.global_position
		if abs(dist_to_player.x) < player_near_radius:
			choose_melee_state()
		else:
			choose_ranged_state()
	else:
		e.moving = true
		end("StartAscend")

func choose_melee_state():
	var p_sign = sign(dist_to_player.x)
	if rng.randi_range(0, 100) < 0:
		end("TailSpinAscend")
	elif p_sign == e.ori:
		end("Bite")
	else:
		end("TailSlam")
	
func choose_ranged_state():
	if rng.randi_range(0, 10) < 2:
		end("StartAscend")
	elif rng.randi_range(0, 10) < 4:
		end("Shoot")
	else:
		end("WalkToPlayer")
