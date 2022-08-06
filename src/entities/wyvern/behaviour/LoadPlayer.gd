extends ActionLeaf


func tick(actor, blackboard):
	if actor.player:
		blackboard.set("player", actor.player)
		return SUCCESS
	return FAILURE
