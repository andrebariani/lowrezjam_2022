extends Node

var player = null

var inputs = {
	dirv = Vector2.ZERO,
	jump = false,
	jump_jp = false,
	jump_jr = false,
	roll = false,
	atk = false,
	atk_jp = false,
	atk_jr = false
}


func init(_entity):
	self.player = _entity


func get_inputs():
	# Reset inputs
	for i in inputs.keys():
		if inputs[i] is bool:
			inputs[i] = false
	
	player.last_input_dir_vector = inputs.dirv
	
	inputs.dirv.x = Input.get_axis("move_left", "move_right")
	inputs.dirv.y = Input.get_axis("move_up", "move_down")
	
	if Input.is_action_pressed("jump"):
		inputs.jump = true
	
	if Input.is_action_just_pressed("jump"):
		inputs.jump_jp = true
	
	if Input.is_action_just_released("jump"):
		inputs.jump_jr = true
	
	if Input.is_action_pressed("atk"):
		inputs.atk = true
	
	if Input.is_action_just_pressed("atk"):
		inputs.atk_jp = true
	
	if Input.is_action_just_released("atk"):
		inputs.atk_jr = true
	
	if Input.is_action_just_pressed("roll") and player.has_skill(player.ROLL):
		inputs.roll = true
