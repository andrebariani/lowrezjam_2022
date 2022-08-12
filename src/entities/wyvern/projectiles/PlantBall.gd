extends Area2D

var speed = 128
var dir = Vector2.LEFT
var plant: Resource

func _physics_process(delta):
	position += speed * delta * dir

func _on_Hitbox_body_entered(_body):
	end()

func _on_Hitbox_area_entered(_area):
	end()
	
func end():
	self.call_deferred("queue_free")
	
