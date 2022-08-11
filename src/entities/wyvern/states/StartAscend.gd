extends State

export var anim_name: String
export var state_next: String = "Aggro"
export var boost: Vector2

func begin():
	e.anim.play(anim_name)
	e.connect("animation_finished", self, "_on_animation_finished")

func run(_delta):
	e.boost()
	
func before_end(_next_state):
	e.disconnect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished(_anim_name):
	if _anim_name == anim_name:
		end(state_next)

func takeoff():
	e.velocity = boost
