extends Node

@export var monster_factory : Node
@export var battle_scene : Node
@export var enemy_party : Node
@export var party : Node
@export var capture_manager : Node
@export var storage_manager : Node


var enemy : Node

func _on_encounter_zone_need_random_encounter(event: EncounterEvent) -> void:
	var monster_instance = monster_factory.create_from_encounter(event)
	enemy_party.add_child(monster_instance)
	enemy = monster_instance
	enemy.set_name("Enemy")
	print(enemy)
	battle_scene.test_battle_ready()
	
func _on_create_party_monster_pressed() -> void:
	capture_manager.capture_monster()

func _on_storage_manager_monster_added(monster: PlayerMonster) -> void:
	var monster_instance = monster_factory.create_from_player_data(monster)
	party.add_child(monster_instance)
