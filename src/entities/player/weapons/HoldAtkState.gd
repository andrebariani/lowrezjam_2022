extends AtkState

func run(_delta):
	e.enablers.move = true
	
	var dir = e.get_input("dirv")
	e.can_roll = true
	if e.get_input("roll"):
		e.roll_input = dir
		end("Roll")
	
	e.max_speed = e.MAX_SPEED
	e.velocity_move = e.approach(e.velocity_move, (e.max_speed / 4) * dir.x, e.floor_acc)
	
	if e.get_input('atk_jr'):
		end(anim_combo)
