extends Node

@export_subgroup("Nodes")
@export var monster_factory : Node

@export var party_monster : Array[PlayerMonster] = []


func add_party_member(encounter: EncounterEvent):
	pass

func _on_storage_manager_monster_added(monster : PlayerMonster) -> void:
	for index in range(7):
		if get_children(index):
			pass
		else:
			monster_factory.create_from_player_data(monster)
