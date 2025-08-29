extends Node

signal enemy_party_ready

var monster_data_array : Array[MonsterData] = []
@export var test_scene : Node

func _ready() -> void:
	pass

func _on_encounter_zone_random_encounter(event: EncounterEvent) -> void:
	var monster = MonsterInstance.new()
	monster.monster_data = event.monster_data
	monster.current_level = event.level
	
	monster.create_monster()
	add_child(monster)
	monster.debug_print()
	enemy_party_ready.emit()
	
func _on_player_monster_needed(node: MonsterInstance):
	pass
	
func construct_monster_data_array():
	print(EncounterEvent)

func _on_battle_scene_battle_ended() -> void:
	for child in get_children():
		queue_free()
		print("child deleted: ", child)
