extends KinematicBody2D
class_name Wyvern

signal animation_finished
signal hit_taken
signal player_detected

export var MAX_HP = 650
export var MAX_SPEED = 32
export var FLOOR_FRICTION = 32
export var AIR_FRICTION = 32
export var CURRENT_ZONE = "Floor1"

onready var stateMachine = $States
onready var wyvern_body = $WyvernBody
onready var jaw_pos = $WyvernBody/root/torso/neck1/neck2/neck3/head/jaw/end
onready var anim := $WyvernBody/AnimationPlayer
onready var raycast := $RayCast2D

onready var labelState = $CanvasLayer/VBoxContainer/State

onready var player = get_tree().get_nodes_in_group("Player")[0]
onready var proj = preload("res://src/entities/wyvern/projectiles/PlantBall.tscn")
var landingSpots = {}

var velocity = Vector2.ZERO
var ori = -1
var player_in_zone = false

var moving := false
var can_sleep := false

var hp = MAX_HP setget _set_hp

func _set_hp(_hp):
	hp = clamp(_hp, 0, MAX_HP)

var unflinchable_states = [
	"Sleep",
	"Standup",
	"Flinch",
	"Ascend",
	"StartAscend",
	"StartDescend",
	"Descend",
	"Topple",
]

var untopplable_states = [
	"Sleep",
	"Flinch",
	"Topple",
]

var statuses = {
	"topple": {
		"timer": Timer.new(),
		"wait_time": 5,
	},
	"poison": {
		"timer": Timer.new(),
		"wait_time": 60,
	}
}

func _ready():
	stateMachine.init(self, "Sleep")
	wyvern_body.init(self)
	labelState.set_text(stateMachine.state_next)
	anim.connect("animation_finished", self, "_on_animation_finished")
	
	var _landingSpots = get_tree().get_nodes_in_group("LandingSpots")
	for l in _landingSpots:
		landingSpots[l.name] = l
		
	for s in statuses.values():
		s.timer.one_shot = true
		s.timer.wait_time = s.wait_time
		add_child(s.timer)


func _physics_process(delta):
	stateMachine.run(delta)


func move_to_x(target_pos: Vector2, near_radius: int):
	velocity.x = MAX_SPEED * ori
	velocity.y = 0
		
	velocity = move_and_slide(velocity, Vector2.UP)
	if global_position.distance_to(Vector2(target_pos.x, global_position.y)) < near_radius:
		return true
	return false

func move_to_y(target_pos: Vector2, near_radius: int, speed = (MAX_SPEED / 2)):
	if global_position > target_pos:
		velocity.y = -speed
	else:
		velocity.y = speed
	velocity.x = 0
		
	velocity = move_and_slide(velocity, Vector2.UP)
	if global_position.distance_to(Vector2(global_position.x, target_pos.y)) < near_radius:
		return true
	return false

func move_to(target_pos: Vector2, near_radius: int):
	if global_position.distance_to(target_pos) > near_radius:
		velocity = (MAX_SPEED * 2) * global_position.direction_to(target_pos)
		velocity = move_and_slide(velocity, Vector2.UP)
		return false
	return true

func boost():
	velocity.x = approach(velocity.x, 0, FLOOR_FRICTION)
	velocity.y = approach(velocity.y, 0, AIR_FRICTION)
	velocity = move_and_slide(velocity, Vector2.UP)


func shoot():
	var p = proj.instance()
	p.global_position = jaw_pos.global_position
	p.dir = Vector2(ori, 0)
	get_parent().add_child( p )
	

func shoot_at_player():
	var p = proj.instance()
	p.global_position = jaw_pos.global_position
	p.dir = jaw_pos.global_position.direction_to(player.global_position)
	get_parent().add_child( p )


func _on_hit_taken(hitbox, hurtbox):
	print_debug("Ouch! Got %d damage at the %s!" % [hitbox.damage, hurtbox.ZONE])
	emit_signal("hit_taken", hitbox, hurtbox)
	hp -= hitbox.damage
	
	if hp < (MAX_HP * 0.2):
		can_sleep = true
	
	if hp < 0:
		stateMachine.node_state.end("Defeat")
		return
		
	if not untopplable_states.has(stateMachine.node_state.name):
		if hitbox.damage > 200:
			stateMachine.node_state.end("Topple")
		elif not unflinchable_states.has(stateMachine.node_state.name):
			stateMachine.node_state.end("Flinch")


func play_anim(anim_name):
	if anim.current_animation != anim_name:
		anim.play(anim_name)


func setup_state_queue(_state_next):
	labelState.set_text(_state_next)
	print_debug(_state_next)


func is_player_visible():
	raycast.cast_to = player.global_position - global_position
	raycast.force_raycast_update()
	
	if raycast.get_collider() is Player :
		return true
	return false

func is_near_player(near_radius):
	var dist_to_player = player.global_position - global_position
	if abs(dist_to_player.x) < near_radius:
		return true
	return false
	
func get_player():
	return player

func pick_landing_spot(_landing_spot := "") -> Position2D:
	if _landing_spot:
		return landingSpots.get(_landing_spot)
	else:
		var id = randi() % landingSpots.size()
		if landingSpots.values()[id].name == CURRENT_ZONE:
			return landingSpots.values()[id - 1]
		return landingSpots.values()[id]

func align_to_target(target: Vector2):
	var _ori = sign(global_position.direction_to(target).x)
	if(ori != _ori ):
		ori = _ori
		wyvern_body.scale.x *= -1
		return true
	return false

func is_wall():
	if not $WyvernBody/BoundaryRays/floor.is_colliding() or \
		$WyvernBody/BoundaryRays/wall.is_colliding():
			return true
	return false

func is_wall_air():
	if $WyvernBody/BoundaryRays/wall.is_colliding():
		return true
	return false

func is_floor():
	if $WyvernBody/BoundaryRays/floor.is_colliding():
		return true
	return false

func toggle_collisions(toggle = false):
	$WyvernBody/BoundaryRays/wall.enabled = toggle
	$WyvernBody/BoundaryRays/floor.enabled = toggle
	raycast.enabled = toggle
	
	$DetectZone/CollisionShape2D.disabled = !toggle
	$Collision.disabled = !toggle

func toggle_collision(toggle):
	$Collision.disabled = !toggle

func _on_animation_finished(_anim_name):
	emit_signal("animation_finished", _anim_name)

func _on_DetectZone_body_entered(_body):
	if _body is Player:
		emit_signal("player_detected")
		player_in_zone = true

func _on_DetectZone_body_exited(_body):
	if _body is Player:
		player_in_zone = false

func approach(a, b, amount):
	if (a < b):
		a += amount
		if (a > b):
			return b
	else:
		a -= amount
		if(a < b):
			return b
	return a
