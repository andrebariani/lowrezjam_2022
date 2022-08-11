extends State

export var near_radius = 16
var falling = false

func begin():
	e.connect("animation_finished", self, "_on_animation_finished")
	
	if not e.is_floor():
		e.anim.play("ToppleDescend")
	else:
		e.anim.play("Defeat")

func run(_delta):
	if falling:
		e.move_to_y(Vector2(e.global_position.x, 999), 8, 64)
		if e.is_floor():
			e.anim.play("ToppleCrash")
			falling = false


func before_end(_next_state):
	if e.is_connected("animation_finished", self, "_on_animation_finished"):
		e.disconnect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished(_anim_name):
	if _anim_name == "ToppleDescend":
		falling = true
	if _anim_name == "Topple" or _anim_name == "ToppleCrash":
		e.anim.play("DefeatCrash")
