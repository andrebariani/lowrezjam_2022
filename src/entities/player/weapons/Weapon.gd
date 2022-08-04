extends Node2D
class_name Weapon

onready var hitbox = $Hitbox/CollisionShape2D
onready var hitbox_area = $Hitbox
onready var entity = null
var equiped = null

onready var current_weapon = null
# String export needs more than one value, because default is empty string
# https://github.com/godotengine/godot/issues/33914
export(String, "Greatclub", "Dual Clubs", "Spear", "Fling") var WEAPON_NAME = "Greatclub"
onready var weapons = {
	Greatclub = preload("res://src/entities/player/weapons/WeaponData.tscn"),
}


var hit_connections = []


func init(_entity):
	self.entity = _entity
	
	equip(WEAPON_NAME)


func equip(_weapon_name):
	if current_weapon:
		unequip()
		
	var weapon_node = weapons[_weapon_name].instance()
	add_child(weapon_node)
	
	current_weapon = weapon_node
	
	for s in current_weapon.attack_states:
		s.weapon = self
		entity.stateMachine.add_state(s)
		entity.animPlayer.add_animation(s.anim_name, s.anim)
		entity.animPlayer.connect("animation_finished", s, "_on_animPlayer_animation_finished")


func unequip():
	for s in current_weapon.attack_states:
		entity.stateMachine.remove_state(s)
		entity.animPlayer.remove_animation(s.anim_name)
		
	current_weapon.call_deferred("queue_free")
	current_weapon = null


func _on_Hitbox_area_entered(_area):
	if _area.has_method("take_hit"):
		if not hit_connections.has(_area.entity_uid):
			_area.take_hit(hitbox_area)
			hit_connections.push_back(_area.entity_uid)
	# hitbox.set_deferred("disabled", true)


func reset_hit_connections():
	hit_connections.clear()
