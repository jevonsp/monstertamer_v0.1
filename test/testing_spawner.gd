extends Control

signal monster_made(node)
signal battle_monster_made(node)

@export var monster_factory : Node
@export var monster_data : MonsterData
@export var monster_data2 : MonsterData
@export var monster_data3 : MonsterData

func _ready() -> void:
	for i in range(1):
		var monster = monster_factory.create_monster(monster_data, 5)
		monster_made.emit(monster)
		print(monster)
	for i in range(1):
		var monster = monster_factory.create_monster(monster_data2, 1)
		monster_made.emit(monster)
		print(monster)
