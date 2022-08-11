extends State

func begin():
	e.play_anim("Fly")

func run(_delta):
	e.move_to_y(Vector2(e.global_position.x, 999), 8)
	
	if e.is_floor():
		end("Descend")

