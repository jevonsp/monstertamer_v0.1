extends Node
signal enemy_party_ready

func _on_encounter_zone_random_encounter(event: EncounterEvent) -> void:
	var enemy = MonsterInstance.new()
	enemy.create_monster(event.monster_data, event.level)
	add_child(enemy)
	enemy.name = "Enemy"
	print("Enemy added at level: ", event.level)

func _on_battle_scene_battle_ended() -> void:
	for child in get_children():
		queue_free()
