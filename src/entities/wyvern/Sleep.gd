extends State

func begin():
	e.anim.play("Sleep")
	e.connect("hit_taken", self, "_on_hit_taken")
	pass
	
func run(_delta):
	pass

func before_end(_next_state):
	e.disconnect("hit_taken", self, "_on_hit_taken")

func _on_hit_taken(_hitbox, _hurtbox):
	end("Standup")
