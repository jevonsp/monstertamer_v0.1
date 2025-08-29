extends Node

signal monster_for_queue(node: MonsterInstance)

func add_party_member(encounter: EncounterEvent):
	pass

func send_to_turn_queue():
	for node in get_children():
		monster_for_queue.emit(node)
