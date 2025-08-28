extends Node2D

@export_subgroup("Nodes")
@export var enemy_party : Node
@export var party : Node
@export var storage_manager : Node

func _ready() -> void:
	for zone in get_tree().get_nodes_in_group("encounter_zone"):
		if zone.has_signal("need_random_encounter"):
			zone.need_random_encounter.connect(_on_encounter_needed)

func _on_encounter_needed(zone: Node):
	print("Encounter needed!")
	var encounter_event = zone.constuct_wild_encounter()
	print(encounter_event)
	enemy_party._on_encounter_zone_random_encounter(encounter_event)
