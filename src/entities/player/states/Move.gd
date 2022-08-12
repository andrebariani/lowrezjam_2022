extends State

func begin():
	e.floor_jump = false

func run(_delta):
	var dir = e.get_input("dirv")
	
	e.max_speed = e.MAX_SPEED
	
	e.velocity_move = e.approach(e.velocity_move, e.max_speed * dir.x, e.floor_acc)
	
	if e.is_on_floor():
		e.velocity_jump = 0
	
	e.can_roll = true
	if e.get_input("roll"):
		e.roll_input = dir
		end("Roll")
	
	if e.get_input("use") and e.equipped_plant:
		end("Use")
	elif e.get_input("jump_jp"):
		e.apply_jump(e.max_jump + e.gravity, true)
		end("Air")
	elif e.get_input("atk"):
		end("Attack")
	elif not e.is_on_floor():
		e.cooldowns.coyote.begin()
		end("Air")
	elif dir.x == 0:
		end("Idle")
