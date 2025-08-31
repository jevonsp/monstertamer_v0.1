extends Node

@export_subgroup("Nodes")
@export var monster_factory : Node

@export var party_monster : Array[MonsterData] = []

func heal_party():
	pass

func add_party_member(encounter: EncounterEvent):
	pass

func _on_storage_manager_monster_added(monster : PlayerMonster) -> void:
	var instance = monster_factory.create_from_player_data(monster)
	add_child(instance)
	print(instance)
