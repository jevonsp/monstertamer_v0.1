extends Area2D

signal battle_monster_ready(monster: MonsterInstance)
signal req_player_stop

@export_range(0, 1) var encounter_chance : float = .5
@export_subgroup("Encounter Table")
@export var available_encounters : Array[MonsterData] = []
@export var level_ranges : Array[Vector2i] = []


@export_subgroup("Nodes")
@export var monster_factory : Node

var player : CharacterBody2D

func _ready() -> void:
	add_to_group("encounter_zone")
	player = get_tree().get_first_node_in_group("player")
	if player: 
		player.moved_to_tile.connect(_on_player_move_in_area)
		print("player connected to encounter zone: ", player)

func _on_player_move_in_area(position: Vector2):
	if get_overlapping_bodies().has(player):
		if calc_encounter(): _create_encounter()
			
func calc_encounter() -> bool:
	if randf() < encounter_chance: return true
	else: return false

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
