extends State

func begin():
	e.floor_jump = false
	e.animPlayer.play("Idle")

func run(_delta):
	if not e.is_on_wall():
		e.velocity_move = e.approach(e.velocity_move, 0, e.floor_friction)
	else:
		e.velocity_move = 0
	e.can_roll = true
	
	if e.is_on_floor():
		e.velocity_jump = 0
	
	if e.get_input("use") and e.equipped_plant:
		end("Use")
	elif e.get_input("roll"):
		e.roll_input = Vector2.ZERO
		end("Roll")
	elif e.get_input("jump_jp"):
		e.apply_jump(e.max_jump + e.gravity, true)
		end("Air")
	elif e.get_input("atk_jp"):
		end("Attack")
	elif e.get_input("dirv").x != 0 and not e.is_on_wall():
		end("Move")
	elif not e.is_on_floor():
		e.cooldowns.coyote.begin()
		end("Air")
