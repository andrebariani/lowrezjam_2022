extends State

onready var player: Player
var last_player_pos = Vector2.ZERO

export var near_radius = 16
var moving = false
var target = null

func begin():
	e.toggle_collisions(false)
	e.anim.play("AreaLeave")
	e.connect("animation_finished", self, "_on_animation_finished")
	
	if e.can_sleep:
		target = e.pick_landing_spot("Nest")
		return
	target = e.pick_landing_spot()
	
	if not target:
		end("StartDescend")
	else:
		e.align_to_target(target.global_position)

func run(_delta):
	if moving:
		if e.move_to(target.global_position, near_radius):
			e.anim.play("AreaArrive")
	
func before_end(_next_state):
	if e.is_connected("animation_finished", self, "_on_animation_finished"):
		e.disconnect("animation_finished", self, "_on_animation_finished")
	
	e.toggle_collisions(true)
	
	if target:
		e.CURRENT_ZONE = target.name

func _on_animation_finished(_anim_name):
	if _anim_name == "AreaLeave":
		e.anim.play("AreaMove")
		moving = true
	if _anim_name == "AreaArrive":
		end("StartDescend")
