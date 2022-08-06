extends KinematicBody2D
class_name Wyvern

signal animation_finished
signal hit_taken

export var MAX_SPEED = 16

onready var stateMachine = $States
onready var body = $WyvernBody
onready var anim := $WyvernBody/AnimationPlayer
onready var raycast := $RayCast2D

onready var labelState = $CanvasLayer/VBoxContainer/State

onready var player = get_tree().get_nodes_in_group("Player")[0]

var velocity = Vector2.ZERO
var ori = -1

func _ready():
	stateMachine.init(self, "Sleep")
	body.init(self)
	labelState.set_text(stateMachine.state_next)
	anim.connect("animation_finished", self, "_on_animation_finished")


func _physics_process(delta):
	raycast.cast_to = player.global_position - global_position
	stateMachine.run(delta)


func move_to(target_position: Vector2):
	velocity.x = MAX_SPEED * ori
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_hit_taken(hitbox, hurtbox):
	print_debug("Ouch! Got %d damage at the %s!" % [hitbox.damage, hurtbox.ZONE])
	emit_signal("hit_taken", hitbox, hurtbox)
	#if stateMachine.node_state.has_method("_on_hit_taken"):
	#	stateMachine.node_state._on_hit_taken(hitbox, hurtbox)
		
func _on_animation_finished(_anim_name):
	emit_signal("animation_finished", _anim_name)


func play_anim(anim_name):
	if anim.current_animation != anim_name: 
		anim.play(anim_name)


func setup_state_queue(_state_next):
	labelState.set_text(_state_next)


func is_player_visible():
	if raycast.get_collider() is Player:
		return true
	return false

func get_player():
	return player

func align_to_target(target: Vector2):
	var _ori = (target - global_position).normalized().x
	if(ori != _ori and _ori != 0):
		ori = _ori
		body.scale.x *= -1

func _on_DetectZone_body_entered(body):
	if body is Player:
		player = body
