extends State

onready var player: Player
var last_player_pos = Vector2.ZERO

export var near_radius = 16
var turning = false
var need_to_align = false

func begin():
	player = e.get_player()
	last_player_pos = player.global_position
	e.connect("animation_finished", self, "_on_animation_finished")
	
	player = e.get_player()
	last_player_pos = player.global_position
	need_to_align = e.align_to_target(last_player_pos)
	
	if need_to_align:
		e.anim.play("TurnAround")
		turning = true
	else:
		e.anim.play("Run")
	
	e.align_to_target(last_player_pos)

func run(_delta):
	if not turning:
		if e.is_wall():
			end("Aggro")
		elif e.move_to_x(last_player_pos, near_radius) or e.is_near_player(near_radius):
			end("Aggro")

func before_end(_next_state):
	if e.is_connected("animation_finished", self, "_on_animation_finished"):
		e.disconnect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished(_anim_name):
	print_debug(_anim_name)
	if _anim_name == "TurnAround":
		turning = false
		e.anim.play("Run")
		
