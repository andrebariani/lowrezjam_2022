extends Area2D

onready var player: Player = null
var gatherable_states = ["Idle", "Move"]

func init(_player):
	player = _player

func _physics_process(_delta):
	for p in get_overlapping_areas():
		if p is Plant:
			print_debug(player.sm.state_curr)
			if player.inputHelper.inputs.gather and gatherable_states.has(player.sm.state_curr):
				player.gathered_plant = p.resource
				if player.gather_plant():
					p.gather()
