extends Area2D
class_name Hitbox

export var damage = 0
export var hitbox_group = ""

var entity = null

func init(_entity):
	_entity = entity
	
	if hitbox_group:
		add_to_group(hitbox_group)

func _set_damage(value):
	damage = value + (value * entity.get_buff("attack"))
