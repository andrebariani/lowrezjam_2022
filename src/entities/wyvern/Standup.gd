extends State
	
func begin():
	e.anim.play("Standup")

func run(_delta):
	pass

func _on_animation_finished(_anim_name):
	if _anim_name == name:
		end("Roar")
