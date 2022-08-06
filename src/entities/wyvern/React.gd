extends ConditionLeaf

func tick(actor, _blackboard):
	if actor.rage:
		return SUCCESS
	return FAILURE
