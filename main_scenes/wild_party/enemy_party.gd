extends Node

var monster_data_array : Array[MonsterData] = []

@export var monster_factory : Node
#@onready var monster_factory = %MonsterFactory
#@onready var battle_manager = get_node("/root/Game/BattleScene/BattleManager")

#func construct_monster_data_array():
	#print(EncounterEvent)
#
#func _on_battle_scene_battle_ended() -> void:
	#for child in get_children():
		#queue_free()
		#print("child deleted: ", child)
#
#func send_to_turn_queue(manager):
	#for node in get_children():
		#if node is MonsterInstance:
			#battle_manager.add_to_turn_queue(node)
