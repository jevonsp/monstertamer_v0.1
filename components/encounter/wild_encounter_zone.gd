extends Area2D

signal battle_monster_ready(monster: MonsterInstance)
signal req_player_stop

@export_subgroup("Encounter Table")
@export var available_encounters : Array[MonsterData] = []
@export var level_ranges : Array[Vector2i] = []

@export_subgroup("Nodes")
@export var monster_factory : Node

func _ready() -> void:
	add_to_group("encounter_zone")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): _create_encounter()

func _create_encounter():
	print("creating encounter")
	var table_index = _pick_index()
	var monster_data = _pick_random_monster(table_index)
	var level = _pick_level(table_index)
	
	var new_monster = monster_factory.create_monster(monster_data, level)
	battle_monster_ready.emit(new_monster)
	req_player_stop.emit()
	print("emitting encounter")
	
func _pick_index() -> int:
	var table_size = available_encounters.size()
	var table_index = randi_range(0, table_size - 1)
	return table_index
func _pick_random_monster(index: int) -> MonsterData:
	var monster = available_encounters[index]
	return monster
func _pick_level(index: int) -> int:
	var level_index = level_ranges[index]
	var level = randi_range(level_index.x, level_index.y)
	return level
