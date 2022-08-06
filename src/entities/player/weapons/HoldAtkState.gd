extends AtkState

func run(_delta):
	if e.get_input('atk_jr'):
		end(anim_combo)
