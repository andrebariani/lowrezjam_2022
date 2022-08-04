extends AtkState
class_name ChargeAtkState

export var charge_frames = 60
export var charge_combo = ["Charge1", "Charge2"]

onready var charge = FrameTimer.new(charge_frames)

func begin():
	hitbox = weapon.hitbox_area
	hitbox.damage = damage
	e.animPlayer.play(anim_name)
	
	charge.begin()

func run(_delta):
	charge.tick()
	
	if e.get_input('atk_jr'):
		var level = ( (charge.value * 10) / (charge_frames) ) / ( (100 / charge_combo.size()) )
		level = clamp(floor(level * 10), 0, charge_combo.size() - 1)
		
		# var test = inverse_lerp(0, charge_frames, charge.value)
		# test = clamp(floor(test * 100), 0, charge_combo.size() - 1)
		
		end(charge_combo[level])


func _on_animPlayer_animation_finished(_anim_name):
	if _anim_name == anim_name:
		end(anim_combo)
