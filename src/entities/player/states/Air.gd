extends State


func run(_delta):
	var dir = e.get_input("dirv")
	
	if not e.cooldowns.air_momentum.is_over():
		if e.cooldowns.air_momentum.value > e.cooldowns.air_momentum.max_value / 3 \
				and dir.x == (e.last_velocity_move_sign):
			e.cooldowns.air_momentum.end()
			e.velocity_move = e.approach(e.velocity_move, e.max_speed * dir.x, e.air_acc)
		else:
			e.velocity_move = e.approach(e.velocity_move, e.max_speed *  \
				-e.last_velocity_move_sign, e.air_acc)
	else:
		e.velocity_move = e.approach(e.velocity_move, e.max_speed * dir.x, e.air_acc)
	
	if e.get_input("jump_jp"):
		if not e.cooldowns.coyote.is_over():
			e.apply_jump(e.max_jump)
		elif e.multijump != 0:
			e.apply_jump(e.max_jump)
			e.multijump -= 1
	
	if e.get_input("jump_jr"):
		if(e.velocity_jump  < -e.min_jump):
			e.velocity_jump = -e.min_jump
	
	if e.is_on_ceiling():
		e.velocity_jump = 0
	
	if e.get_input("roll") and e.can_roll:
		e.cooldowns.roll.begin()
		e.roll_input = dir
		end("Roll")
	elif e.has_skill(e.WALLJUMP) and e.is_on_wall() and \
				e.get_last_slide_collision().get_normal().x != dir.x and \
			 	dir.x != 0 and e.velocity_jump > 0:
		e.velocity_jump = 0
		e.last_velocity_move_sign = sign(e.velocity_move)
		e.cooldowns.walljump.begin()
		end("Walljump")
	elif e.is_on_floor():
		e.velocity_jump = 0
		e.multijump = e.max_multijump
		if e.velocity_move == 0:
			end("Idle")
		else:
			end("Move")
