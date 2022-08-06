extends ActionLeaf

var anim_finished := false

func tick(actor, _blackboard):
	actor.play_anim(name)
	return SUCCESS
