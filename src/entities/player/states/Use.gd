extends State

var equipped_plant: String

func begin():
	e.animPlayer.connect("animation_finished", self, "_on_animation_finished")
	e.animPlayer.play("Use")
	
	equipped_plant = e.equipped_plant
	print_debug(equipped_plant)

func run(_delta):
	var dir = e.get_input("dirv")
	
	e.max_speed = e.MAX_SPEED
	
	e.velocity_move = e.approach(e.velocity_move, (e.max_speed / 2) * dir.x, e.floor_acc)
	
	if e.is_on_floor():
		e.velocity_jump = 0
	
	e.can_roll = true
	if e.get_input("roll"):
		e.roll_input = dir
		end("Roll")

func before_end(_state_next):
	if e.animPlayer.is_connected("animation_finished", self, "_on_animation_finished"):
		e.animPlayer.disconnect("animation_finished", self, "_on_animation_finished")


func _on_animation_finished(_anim_name):
	if _anim_name == "Use":
		e.use_equipped_plant(equipped_plant)
		end("Move")
