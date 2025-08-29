extends Node

signal enemy_monster_for_queue(node: MonsterInstance)


var monster_data_array : Array[MonsterData] = []

@onready var monster_factory = %MonsterFactory

func construct_monster_data_array():
	print(EncounterEvent)

func _on_battle_scene_battle_ended() -> void:
	for child in get_children():
		queue_free()
		print("child deleted: ", child)

func send_to_turn_queue():
	for node in get_children():
		enemy_monster_for_queue.emit(node)
