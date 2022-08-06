extends ActionLeaf

func tick(actor, _blackboard):
	actor.play_anim("Idle")

	return RUNNING
