extends Control

signal monster_made(node)

@export var monster_factory : Node
@export var monster_data : MonsterData

func _ready() -> void:
	for i in range(6):
		var monster = monster_factory.create_monster(monster_data, 1)
		monster_made.emit(monster)
		print(monster)

func _on_button_pressed() -> void:
	pass
