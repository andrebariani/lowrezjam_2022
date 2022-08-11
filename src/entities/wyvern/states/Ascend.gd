extends State

var last_player_pos = Vector2.ZERO

export var altitude = 32
var alt = 0

func begin():
	e.anim.play("Fly")
	alt = e.global_position.y - altitude

func run(_delta):
	if e.move_to_y(Vector2(e.global_position.x, alt), 8):
		if e.moving:
			end("MoveToArea")
		else: 
			end("AirAggro")
