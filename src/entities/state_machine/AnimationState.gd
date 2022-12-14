extends State

export var anim_name: String
export var state_next: String = "Aggro"
export var should_align: bool = false

onready var player: Player
var last_player_pos = Vector2.ZERO
var need_to_align = false

func begin():
	e.connect("animation_finished", self, "_on_animation_finished")
	
	if should_align:
		player = e.get_player()
		last_player_pos = player.global_position
		need_to_align = e.align_to_target(last_player_pos)
	
	if need_to_align:
		e.anim.play("TurnAround")
	else:
		e.anim.play(anim_name)

func run(_delta):
	pass
	
func before_end(_next_state):
	if e.is_connected("animation_finished", self, "_on_animation_finished"):
		e.disconnect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished(_anim_name):
	if _anim_name == "TurnAround":
		e.anim.play(anim_name)
	elif _anim_name == anim_name:
		end(state_next)
