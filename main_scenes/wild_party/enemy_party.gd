extends Node

var monster_data_array : Array[MonsterData] = []

func _ready() -> void:
	pass

func _on_encounter_zone_random_encounter(event: EncounterEvent) -> void:
	var monster = MonsterInstance.new()
	monster.monster_data = event.monster_data
	monster.current_level = event.level
	
	monster.create_monster()
	add_child(monster)
	monster.debug_print()
	
func construct_monster_data_array():
	print(EncounterEvent)
