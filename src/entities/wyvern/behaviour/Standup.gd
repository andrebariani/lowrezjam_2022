extends ActionLeaf

export var anim_name: String
var anim_finished := false

func tick(actor, _blackboard):
	actor.play_anim("Standup")
	
	if not actor.is_connected("animation_finished", self, "_on_animation_finished"):
		actor.connect("animation_finished", self, "_on_animation_finished")
	if anim_finished:
		actor.disconnect("animation_finished", self, "_on_animation_finished")
		anim_finished = false
		return SUCCESS
		
	return RUNNING


func _on_animation_finished(_anim_name):
	if _anim_name == name:
		anim_finished = true
