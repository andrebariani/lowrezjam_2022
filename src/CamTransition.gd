extends Area2D

onready var camera: Camera2D = get_tree().get_nodes_in_group("PlayerCamera")[0]
onready var limit_tl = get_node("Limits/TopLeft").position
onready var limit_br = get_node("Limits/BottomRight").position

func _on_CamTransition_body_entered(body):
	if body is Player:
		camera.limit_top = limit_tl.y
		camera.limit_left = limit_tl.x
		camera.limit_bottom = limit_br.y
		camera.limit_right = limit_br.x
		
