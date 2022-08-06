extends ActionLeaf

func tick(actor, blackboard):
	if actor.player:
		blackboard.set("player_last_pos", actor.player.global_position)
		return SUCCESS
	return FAILURE
