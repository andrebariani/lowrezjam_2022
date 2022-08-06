extends ConditionLeaf

export var anim_name := ""
var anim_finished := false

func tick(actor, _blackboard):
	if not actor.is_connected("animation_finished", self, "_on_animation_finished"):
		actor.connect("animation_finished", self, "_on_animation_finished")
	
	if anim_finished:
		actor.disconnect("animation_finished", self, "_on_animation_finished")
		return SUCCESS
		
	return FAILURE


func _on_animation_finished(_anim_name):
	if _anim_name == anim_name:
		anim_finished = true
