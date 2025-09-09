extends Area2D

signal monster_ready(monster: MonsterInstance)

@export_subgroup("Encounter Table")
@export var available_encounters : Array[MonsterData] = []
@export var level_ranges : Array[Vector2i] = []

@export_subgroup("Nodes")
@export var battle : Node2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): pass

func _create_encounter():
	var table_index = _pick_index()
	var monster_data = _pick_random_monster(table_index)
	var level = _pick_level(table_index)
	
	

func _pick_index() -> int:
	var table_size = available_encounters.size()
	var table_index = randi_range(0, table_size)
	return table_index
func _pick_random_monster(index: int) -> MonsterData:
	var monster = available_encounters[index]
	return monster
func _pick_level(index: int) -> int:
	var level_index = level_ranges[index]
	var level = randi_range(level_index.x, level_index.y)
	return level
