extends Node

@onready var battle_manager = get_node("/root/Game/BattleScene/BattleManager")

func add_party_member(encounter: EncounterEvent):
	pass

func send_to_turn_queue(manager):
	for node in get_children():
		if node is MonsterInstance:
			battle_manager.add_to_turn_queue(node)
