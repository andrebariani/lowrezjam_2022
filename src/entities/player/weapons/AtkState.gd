extends State
class_name AtkState

export var anim: Animation
export var anim_name: String = "Attack"
export var anim_combo: String
export var damage: int
export var frames_for_next: int

onready var weapon = null
onready var hitbox = null

var attacked = false

onready var timer = FrameTimer.new(frames_for_next)

func begin():
	hitbox = weapon.hitbox_area
	hitbox.damage = damage + (damage * e.get_buff("attack"))
	e.animPlayer.play(anim_name)
	
	timer.value = 0
	timer.max_value = frames_for_next
	
	e.enablers.move = false
	attacked = false


func run(_delta):
	timer.tick()
	
	e.velocity_move = e.approach(e.velocity_move, 0, e.floor_friction)
	
	if e.get_input('atk'):
		attacked = true
	
	if timer.is_over():
		if anim_combo and attacked:
			end(anim_combo)


func before_end(_next_state):
	e.enablers.move = true
	weapon.reset_hit_connections()


func _on_animPlayer_animation_finished(_anim_name):
	if _anim_name == anim_name:
		end("Idle")
