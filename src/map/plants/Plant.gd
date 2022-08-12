extends Area2D
class_name Plant

export var resource: Resource
onready var zone = "Plants_" + get_parent().name

var is_being_gathered = false

func _ready():
	add_to_group(zone)

func gather():
	queue_free()
