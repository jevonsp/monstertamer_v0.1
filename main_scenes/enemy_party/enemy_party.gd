extends Node

signal battle_started

var monster_data_array : Array[MonsterData] = []

@export var monster_factory : Node

func add_monster(event):
	var monster = monster_factory.create_from_encounter(event)
	add_child(monster)
	battle_started.emit()
	print("battle_started emitted")
