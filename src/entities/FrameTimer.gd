extends Node
class_name FrameTimer

var max_value: float
var value: float
var _paused: bool

func _init(time):
	max_value = time
	value = time
	_paused = false


func tick():
	if !_paused:
		value = min(value + 1, max_value)


func is_over():
	return value >= max_value


func set_paused(p):
	_paused = p


func begin(_time = 0):
	value = 0


func end():
	value = max_value
