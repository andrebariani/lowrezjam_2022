extends ActionLeaf

var hit_taken := false

func tick(actor, _blackboard):
	actor.play_anim("Sleep")
	
	if not actor.is_connected("hit_taken", self, "_on_hit_taken"):
		actor.connect("hit_taken", self, "_on_hit_taken")
	if self.hit_taken:
		actor.disconnect("hit_taken", self, "_on_hit_taken")
		hit_taken = false
			
		return SUCCESS
		
	return RUNNING


func _on_hit_taken(_hitbox, _hurtbox):
	hit_taken = true
