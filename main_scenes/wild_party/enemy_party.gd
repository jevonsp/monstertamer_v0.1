extends Node

signal enemy_party_ready

var monster_data_array : Array[MonsterData] = []

@onready var monster_factory = %MonsterFactory

func _ready() -> void:
	for zone in get_tree().get_nodes_in_group("encounter_zone"):
		zone.need_random_encounter.connect(_on_random_encounter)

func _on_random_encounter(event: EncounterEvent) -> void:
	pass
	
func _on_player_monster_needed(node: MonsterInstance):
	pass
	
func construct_monster_data_array():
	print(EncounterEvent)

func _on_battle_scene_battle_ended() -> void:
	for child in get_children():
		queue_free()
		print("child deleted: ", child)
