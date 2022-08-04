extends Node2D

var group = "MonsterHurtbox"
var entity: Wyvern


func init(_entity):
	entity = _entity
	
	var hurtboxes = get_tree().get_nodes_in_group(group)
	
	for h in hurtboxes:
		h.entity_uid = _entity.get_instance_id()
		h.connect("hit_taken", entity, "_on_hit_taken")
