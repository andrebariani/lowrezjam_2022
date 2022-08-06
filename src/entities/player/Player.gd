class_name Player
extends KinematicBody2D

export (int) var MAX_SPEED = 64
export (int) var MAX_JUMP = 64
export (int) var MIN_JUMP = 16
export (int) var FLOOR_ACC = 8
export (int) var FLOOR_FRICTION = 16
export (int) var AIR_ACC = 2
export (int) var GRAVITY = 16
export (int) var AIR_FINAL_SPEED = 128
export (int) var COYOTE_JUMP_FRAMES = 7
export (int) var ROLL_SPEED = 700
export (int) var ROLL_FRAMES
export (int) var MAX_MULTIJUMP = 0
export (int) var WALLSLIDE_SPEED = 100
export (int) var WALLJUMP_FRAMES = 10
export (int) var AIR_MOMENTUM_FRAMES = 10

enum {ROLL, WALLJUMP}
export (int, FLAGS, "Roll", "Walljump") var SKILLS = 0

func has_skill(skill):
	return SKILLS & (1 << skill)

onready var max_speed = MAX_SPEED
onready var gravity = GRAVITY
onready var air_final_speed = AIR_FINAL_SPEED
onready var max_jump = MAX_JUMP
onready var min_jump = MIN_JUMP
onready var floor_acc = FLOOR_ACC
onready var floor_friction = FLOOR_FRICTION
onready var air_acc = AIR_ACC
onready var roll_speed = ROLL_SPEED
onready var max_multijump = MAX_MULTIJUMP
onready var wallslide_speed = WALLSLIDE_SPEED

onready var sm = $States
onready var inputHelper = $Inputs
onready var sprite = $Sprite
onready var animPlayer = $anim
onready var stateMachine = $States
onready var hurtbox = $Hurtbox

onready var debugVelocity = $CanvasLayer/Debug/Velocity
onready var debugState = $CanvasLayer/Debug/StateQueue

var has_control = true
var ori = 1

var velocity = Vector2.ZERO
var velocity_jump = 0
var velocity_move = 0
var floor_normal = Vector2.UP

var floor_jump = false
var multijump = 0

var last_input_dir_vector = Vector2.ZERO
var last_velocity_move_sign # Used mainly in walljumpsies
var roll_input: Vector2

var can_roll = true
var gravity_dir
var gravity_on = true
var last_gravity

var enablers = {
	move = true,
	attack = true,
	shoot = true,
	roll = true,
	string = true
}

onready var cooldowns = {
	"coyote": FrameTimer.new(COYOTE_JUMP_FRAMES),
	"roll": FrameTimer.new(ROLL_FRAMES),
	"walljump": FrameTimer.new(WALLJUMP_FRAMES),
	"air_momentum": FrameTimer.new(AIR_MOMENTUM_FRAMES),
}

onready var weapon = $Weapon 


func _ready():
	sm.init(self, "Idle")
	inputHelper.init(self)
	
	weapon.init(self)


func _physics_process(delta):
	if has_control:
		inputHelper.get_inputs()
	
	update_cooldowns()
	sm.run(delta)
	apply_velocity(delta)


func apply_jump(strength := max_jump + gravity, is_floor_jump := false):
	velocity_jump = -(strength)
	floor_jump = is_floor_jump


func apply_velocity(_delta):
	var _snaps = [Vector2(0, 16), Vector2(16, 0), Vector2(0, -16), Vector2(-16, 0)]

	if sm.state_curr == "Walljump":
		if ori != -last_velocity_move_sign:
			change_ori(-last_velocity_move_sign)
	else:
		change_ori(sign(get_input("dirv").x))
	
	if gravity_on:
		velocity_jump = approach(velocity_jump, air_final_speed, gravity)

	velocity.x = velocity_move
	velocity.y = -floor_normal.y * velocity_jump

	velocity = move_and_slide(velocity, floor_normal)


func set_gravity(_grav):
	if _grav != gravity_dir:
		last_gravity = gravity_dir
		gravity_dir = _grav
		
		floor_normal = _grav


func change_ori(_ori):
	if(ori != _ori and _ori != 0):
		ori = _ori
		self.scale.x *= -1


func get_input(input: String):
	return inputHelper.inputs[input]


func update_cooldowns():
	for cd in cooldowns.values():
		cd.tick()


func setup_state_queue(state):
	debugState.set_text("%s <= %s" % [state, debugState.get_text()])


func update_debug():
	debugVelocity.set_text("(%5d, %5d)" % [velocity.x, velocity.y])


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


func _on_Hurtbox_area_entered(_area):
	if _area is Hitbox:
		print_debug("oh no")
