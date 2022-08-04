extends State

func begin():
	e.anim.play("Sleep")
	pass
	
func run(_delta):
	pass
	
func _on_hit_taken(_hitbox, _hurtbox):
	end("Standup")
