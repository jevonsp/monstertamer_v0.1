class_name MonsterInstance
extends Node

@export var monster_data : MonsterData

@export_subgroup("Stats")
@export var preset_stats : bool = false
@export var max_hp : int
@export var current_hp : int
@export var current_speed : int
@export var current_attack : int
@export var current_defense : int
@export var current_dexterity : int

func _ready() -> void:
	create_monster(monster_data, 1)
	calculate_stats()
	
func create_monster(data: MonsterData, level: int):
	data = monster_data
	calculate_stats()
	
func calculate_stats():
	if !preset_stats:
		max_hp = monster_data.base_hp
		current_speed = monster_data.base_speed
		current_attack = monster_data.base_attack
		current_defense = monster_data.base_defense
		current_dexterity = monster_data.base_dexterity
	print(max_hp)
