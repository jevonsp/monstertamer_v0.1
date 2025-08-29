extends Node

@export var enemy_party : Node
@export var storage_manager : Node

func capture_monster():
	var node = enemy_party.get_child(0)
	var pm = PlayerMonster.create_player_monster(node)
	storage_manager.add_monster_to_caught_monsters(pm)
	node.queue_free()
