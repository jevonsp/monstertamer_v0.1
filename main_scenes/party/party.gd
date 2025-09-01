extends Node

@export_subgroup("Nodes")
@export var monster_factory : Node
@export var battle_scene : Node

@export var party_monster : Array[MonsterData] = []

func _ready() -> void:
	pass

func heal_party():
	print("got asked for healing")
	for monster in get_children():
		monster.health_component.heal()

func _on_storage_manager_monster_added(monster : PlayerMonster) -> void:
	var instance = monster_factory.create_from_player_data(monster)
	instance.battle_scene = battle_scene
	add_child(instance)
	instance.name = "PlayerMonster"
	print(instance)
