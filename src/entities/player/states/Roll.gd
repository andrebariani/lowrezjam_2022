extends State


func begin():
	e.has_control = false
	e.gravity_on = false
	e.cooldowns.roll.begin()
	e.velocity_move = e.roll_speed * e.ori

func run(_delta):
	e.can_roll = false
	
	e.velocity_move = e.approach(e.velocity_move, 0, e.floor_friction / 2)
	e.velocity_jump = 0
	
	if e.is_on_wall() and e.get_last_slide_collision().get_normal().x != e.ori:
		e.cooldowns.roll.end()
		if e.has_skill(e.WALLJUMP):
			if not e.is_on_floor():
				e.last_velocity_move_sign = sign(e.velocity_move)
				e.cooldowns.walljump.value = 0
				end("Walljump")
			else:
				end("Idle")
		else:
			end("Air")
	elif e.cooldowns.roll.is_over():
		if e.is_on_floor():
			e.velocity_jump = 0
			end("Move")
		else:
			end("Air")


func end(next_state: String):
	e.has_control = true
	e.gravity_on = true
	stateMachine.change_state(next_state)
