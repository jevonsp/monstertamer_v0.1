extends Control

signal monster_made(node)

@export var monster_factory : Node
@export var monster_data : MonsterData
@export var monster_data2 : MonsterData

func _ready() -> void:
	for i in range(2):
		var monster = monster_factory.create_monster(monster_data, 1)
		monster_made.emit(monster)
		print(monster)
	for i in range(2):
		var monster = monster_factory.create_monster(monster_data2, 10)
		monster_made.emit(monster)
		print(monster)
