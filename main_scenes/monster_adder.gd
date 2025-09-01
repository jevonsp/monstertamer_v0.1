extends Area2D

signal monster_get(pm : PlayerMonster)

@export_subgroup("Nodes")
@export var party : Node
@export var monster_factory : Node

@export var monster_data : MonsterData
@export var level : int

var monster_node : Node

func _ready() -> void:
	var event = EncounterEvent.new(monster_data, level)
	var instance = monster_factory.create_from_encounter(event)
	add_child(instance)
	monster_node = instance

# Emits to Storage
func _on_body_entered(body: Node2D) -> void:
	var pm = PlayerMonster.create_player_monster(monster_node)
	monster_get.emit(pm)
