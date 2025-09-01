extends Node

signal monster_captured(pm : PlayerMonster)

@export_subgroup("Nodes")
@export var party : Node
@export var enemy_party : Node
@export var storage_manager : Node
@export var monster_adder : Node
@export var monster_factory : Node
@export var battle_scene : Node2D

var current_event_monster : EncounterEvent

func _ready() -> void:
	pass

func attempt_capture(mi: MonsterInstance):
	var capture_chance = 1
	if randf() < capture_chance:
		capture_monster(mi)

func capture_monster(mi : MonsterInstance):
	var pm = PlayerMonster.create_player_monster(mi)
	monster_captured.emit(pm)
	if party.get_child_count() < 6:
		var new_instance = monster_factory.create_from_pm(pm)
		party.add_child(new_instance)
	enemy_party.remove_child(mi)
	mi.queue_free()
	if enemy_party.get_child_count() == 0:
		battle_scene.capture_succeeded()

func _on_encounter_zone_current_wild_monster(event: EncounterEvent) -> void:
	print("recieved encounter event")
	current_event_monster = event
