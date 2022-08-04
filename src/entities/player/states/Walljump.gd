extends State

func begin():
	e.gravity_on = false
	e.cooldowns.walljump.begin()

func run(_delta):
	var dir = e.get_input("dirv")
	
	e.velocity_jump = e.approach(e.velocity_jump, e.wallslide_speed, e.gravity * 0.8)
	# e.velocity_jump = 0
	
	e.floor_jump = false
	e.can_roll = true
	
	if e.last_velocity_move_sign != dir.x or dir.x == 0:
		if e.cooldowns.walljump.is_over():
			e.velocity_move = 0
			end("Air")
			return
	else:
		e.cooldowns.walljump.value = 0
	
	if e.is_on_floor():
		e.velocity_jump = 0
		end("Idle")
	elif e.get_input("roll"):
		e.cooldowns.roll.value = 0
		e.roll_input = dir
		end("Roll")
	elif e.get_input("jump_jp"):
		e.apply_jump(e.max_jump + 50)
		e.velocity_move = e.last_velocity_move_sign * -1 * (e.max_speed)
		e.cooldowns.air_momentum.value = 0
		end("Air")
	elif not e.is_on_wall():
		e.velocity_move = 0
		end("Air")


func before_end(_next_state):
	e.gravity_on = true
