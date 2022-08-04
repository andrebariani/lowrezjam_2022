extends Area2D

onready var player: Player

func ready():
	set_physics_process(false)

func _physics_process(_delta):
	if player:
		player.velocity_move += 100
		

func _on_Wind_body_entered(body):
	if body is Player:
		player = body
		set_physics_process(true)

func _on_Wind_body_exited(body):
	if body is Player:
		set_physics_process(false)
