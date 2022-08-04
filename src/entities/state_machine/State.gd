class_name State
extends Node

var stateMachine = null
onready var e

var initialized = false

func initialize():
	if !initialized:
		initialized = true
		init()

func init():
	pass

func begin():
	# when state start
	pass

func run(_delta):
	pass

func before_end(_next_state):
	pass

func end(next_state: String):
	before_end(next_state)
	
	# when state exit
	stateMachine.change_state(next_state)
	
