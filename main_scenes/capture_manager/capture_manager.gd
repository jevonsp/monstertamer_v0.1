extends Node

signal monster_captured

@export var enemy_party : Node
@export var storage_manager : Node
@export var monster_adder : Node
@export var monster_factory : Node

func _ready() -> void:
	pass

# Connected from Battle Scene
func capture_monster():
	var node = enemy_party.get_child(0)
	var pm = PlayerMonster.create_player_monster(node)
	storage_manager.add_monster_to_caught_monsters(pm)
	monster_captured.emit()
	node.queue_free()
	
	
