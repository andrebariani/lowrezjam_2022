extends Composite

class_name SelectorComposite, "../../icons/selector.svg"

var current_child := ""

func tick(actor, blackboard):
	for c in get_children():
		var response = c.tick(actor, blackboard)
		
		if c is ConditionLeaf:
			blackboard.set("last_condition", c)
			blackboard.set("last_condition_status", response)


		if response != FAILURE:
			if c is ActionLeaf and response == RUNNING:
				blackboard.set("running_action", c)
				
			if current_child != c.name:
				current_child = c.name
				print_debug("Executing %s" % c.name)
			return response
			

	return FAILURE
