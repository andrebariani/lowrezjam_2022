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
export (int) var ROLL_SPEED = 88
export (int) var ROLL_FRAMES = 7
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
onready var interact = $Interact
onready var ui = $CanvasLayer/UI
onready var item_icon = $CanvasLayer/UI/ItemIcon
onready var item_qtt = $CanvasLayer/UI/Qtt

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

var statuses = {
	"stun": {
		"timer": Timer.new(),
		"wait_time": 5,
	},
	"poison": {
		"timer": Timer.new(),
		"wait_time": 60,
	}
}

var buffs = {
	"attack": {
		"timer": Timer.new(),
		"wait_time": 60,
		"value": 0,
	},
	"defense": {
		"timer": Timer.new(),
		"wait_time": 60,
		"value": 0,
	}
}

onready var weapon = $Weapon 

var MAX_HP = 100
var hp = MAX_HP setget _set_hp

func _set_hp(_hp):
	hp = clamp(_hp, 0, MAX_HP)
	print_debug("hp: %d  ->  hp: %d", [hp, _hp])

onready var gathered_plant: Resource
onready var equipped_plant: String
onready var inventory = []
onready var stash = {}
onready var inventory_id = 0 setget _set_inventory_id

func _set_inventory_id(_id):
	if _id < 0:
		inventory_id = inventory.size() - 1
	elif _id > inventory.size() - 1:
		inventory_id = 0
	else:
		inventory_id = clamp(_id, 0, inventory.size() - 1)
	

func _ready():
	sm.init(self, "Idle")
	inputHelper.init(self)
	weapon.init(self)
	interact.init(self)
	
	for s in statuses.values():
		s.timer.one_shot = true
		s.timer.wait_time = s.wait_time
		add_child(s.timer)
		
	for b in buffs.values():
		b.timer.one_shot = true
		b.timer.wait_time = b.wait_time
		add_child(b.timer)


func _physics_process(delta):
	if has_control:
		inputHelper.get_inputs()
	if Input.is_action_just_released("switch_item_right"):
		self.inventory_id += 1
		setup_equipped_plant()
	elif Input.is_action_just_released("switch_item_left"):
		self.inventory_id -= 1
		setup_equipped_plant()
	
	update_cooldowns()
	sm.run(delta)
	apply_velocity(delta)


func setup_equipped_plant():
	if inventory.size():
		equipped_plant = inventory[self.inventory_id]
		item_icon.texture = stash[equipped_plant].resource.icon
		item_qtt.set_text(str(stash[equipped_plant].quantity))

func apply_jump(strength := max_jump + gravity, is_floor_jump := false):
	velocity_jump = -(strength)
	floor_jump = is_floor_jump


func apply_velocity(_delta):
	var _snaps = [Vector2(0, 16), Vector2(16, 0), Vector2(0, -16), Vector2(-16, 0)]

	if sm.state_curr == "Walljump":
		if ori != -last_velocity_move_sign:
			change_ori(-last_velocity_move_sign)
	elif enablers.move:
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
		var total_damage = _area.damage - (_area.damage * get_buff("defense"))
		print_debug("Ouchie! Player took %d damage!" % _area.damage )
		hp -= total_damage


func gather_plant() -> bool:
	if stash.has(gathered_plant.plant_id):
		if stash[gathered_plant.plant_id].quantity == gathered_plant.plant_stack:
			return false
			
		var new_qtde = clamp(stash[gathered_plant.plant_id].quantity + gathered_plant.plant_yield, 0, gathered_plant.plant_stack)
		stash[gathered_plant.plant_id].quantity = new_qtde
	else:
		stash[gathered_plant.plant_id] = {
			"resource": gathered_plant,
			"quantity": gathered_plant.plant_yield,
			"stack": gathered_plant.plant_stack
		}
		
		inventory.push_back(gathered_plant.plant_id)
	
	equipped_plant = gathered_plant.plant_id
	gathered_plant = null
	
	item_icon.texture = stash[equipped_plant].resource.icon
	item_qtt.set_text(str(stash[equipped_plant].quantity))
	
	print_debug(inventory)
	print_debug(stash)
	return true


func use_equipped_plant(_equipped_plant):
	var plant = stash[_equipped_plant].resource
	for e in plant.effects.keys():
		if e == "heal":
			self.hp += MAX_HP * plant.effects[e]
		elif e == "poison":
			# throw
			pass
		elif e == "stun":
			# throw
			pass
		elif e in buffs:
			buffs[e].value = plant.effects[e]
			buffs[e].timer.start()
			
	stash[_equipped_plant].quantity -= 1
	item_qtt.set_text(str(stash[equipped_plant].quantity))
	if stash[_equipped_plant].quantity == 0:
		stash.erase(_equipped_plant)
		inventory.erase(_equipped_plant)
		equipped_plant = ""
		
		item_icon.texture = null
		item_qtt.set_text("")
		
	print_debug(inventory)
	print_debug(stash)


func get_buff(key: String):
	if buffs.has(key):
		if buffs[key].timer.is_stopped():
			return 0
		else:
			return buffs[key].value
	return null
