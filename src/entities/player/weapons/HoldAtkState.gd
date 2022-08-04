extends AtkState

func run(_delta):
	if e.get_input('atk_jr'):
		print_debug("huh")
		end(anim_combo)
