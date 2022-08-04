extends KinematicBody2D
class_name Wyvern

signal hit_taken
signal animation_finished

onready var ai := $BeehaveRoot
onready var body := $WyvernBody
onready var anim := $WyvernBody/AnimationPlayer

onready var labelState = $CanvasLayer/VBoxContainer/State

onready var player = get_tree().get_nodes_in_group("Player")[0]

var velocity := Vector2.ZERO

func _ready():
	body.init(self)
	anim.connect("animation_finished", self, "_on_animation_finished")


func _physics_process(_delta):
	if ai.get_running_action():
		labelState.set_text(str(ai.get_running_action().name))


func move_to(target_position: Vector2, delta: float):
	velocity.x += global_position.direction_to(target_position).x * 32
	
	print_debug(velocity)
	
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
