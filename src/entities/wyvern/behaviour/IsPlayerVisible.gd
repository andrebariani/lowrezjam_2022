extends ConditionLeaf

func tick(actor, blackboard):
	var player = blackboard.get("player")
	actor.raycast.cast_to = player.global_position - actor.global_position
	actor.raycast.force_raycast_update()
	if actor.raycast.get_collider() is Player:
		return SUCCESS
	else:
		return FAILURE
		
