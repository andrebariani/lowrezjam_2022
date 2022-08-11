extends State

var frame = 0

func begin():
	e.anim.play("Topple")
	e.connect("animation_finished", self, "_on_animation_finished")
	e.connect("hit_taken", self, "_on_hit_taken")

func before_end(_next_state):
	if e.is_connected("animation_finished", self, "_on_animation_finished"):
		e.disconnect("animation_finished", self, "_on_animation_finished")
	if e.is_connected("hit_taken", self, "_on_hit_taken"):
		e.disconnect("hit_taken", self, "_on_hit_taken")

func run(_delta):
	frame += 1
	if frame % 60 == 0:
		e.hp += 1
	pass

func _on_hit_taken(_hitbox, _hurtbox):
	end("Standup")

func _on_animation_finished(_anim_name):
	if _anim_name == "Topple":
		e.anim.play("Sleep")
