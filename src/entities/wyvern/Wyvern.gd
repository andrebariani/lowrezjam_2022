extends KinematicBody2D
class_name WyvernBT

signal hit_taken

onready var stateMachine = $States
onready var ai = $BeehaveRoot
onready var body = $WyvernBody
onready var anim := $WyvernBody/AnimationPlayer


onready var labelState = $CanvasLayer/VBoxContainer/State

onready var player = get_tree().get_nodes_in_group("Player")[0]

func _ready():
	stateMachine.init(self, "Sleep")
	body.init(self)
	labelState.set_text(stateMachine.state_next)
	anim.connect("animation_finished", self, "_on_animation_finished")


func _physics_process(delta):
	stateMachine.run(delta)


func _on_hit_taken(hitbox, hurtbox):
	print_debug("Ouch! Got %d damage at the %s!" % [hitbox.damage, hurtbox.ZONE])
	emit_signal("hit_taken")
	#if stateMachine.node_state.has_method("_on_hit_taken"):
	#	stateMachine.node_state._on_hit_taken(hitbox, hurtbox)
		
func _on_animation_finished(_anim_name):
	if stateMachine.node_state.has_method("_on_animation_finished"):
		stateMachine.node_state._on_animation_finished(_anim_name)
		emit_signal("animation_finished")


func play_anim(anim_name):
	if anim.current_animation != anim_name: 
		anim.play(anim_name)


func setup_state_queue(_state_next):
	labelState.set_text(_state_next)
