extends State

func begin():
	e.anim.play("AwaitPlayer")
	e.connect("player_detected", self, "_on_player_detected")
	pass

func run(_delta):
	if e.player_in_zone:
		end("Aggro")

func before_end(_next_state):
	if e.is_connected("player_detected", self, "_on_player_detected"):
		e.disconnect("player_detected", self, "_on_player_detected")

func _on_player_detected():
	end("Aggro")
