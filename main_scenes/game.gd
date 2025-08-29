extends Node2D

@export_subgroup("Nodes")
@export var enemy_party : Node
@export var party : Node
@export var storage_manager : Node
@export var monster_factory : Node


func _ready() -> void:
	for zone in get_tree().get_nodes_in_group("encounter_zone"):
		zone.need_random_encounter.connect(_on_encounter_needed)

func _on_encounter_needed(event: EncounterEvent) -> void:
	var monster = monster_factory.create_from_encounter(event)
	enemy_party.add_child(monster)
