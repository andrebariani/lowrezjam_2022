extends Area2D

signal hit_taken(hitbox, hurtbox)

export(int, "Body", "Head", "Tail") var ZONE
export var hurtbox_group = ""

var entity_uid = null
onready var col = $CollisionShape2D

func _ready():
	# connect("area_entered", self, "_on_Hurtbox_area_entered")
	
	if hurtbox_group:
		add_to_group(hurtbox_group)

func take_hit(hitbox):
	emit_signal("hit_taken", hitbox, self)
