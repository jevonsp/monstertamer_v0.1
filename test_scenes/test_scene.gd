extends Node

signal monster_caught(monster)

@export var encounter_zone : Area2D
@export var enemy_party : Node
@export var catch_enemy : Button


func _ready() -> void:
	pass

func test_encounter():
	var encounter_event = encounter_zone.constuct_wild_encounter()
	print(encounter_event)
	enemy_party._on_encounter_zone_random_encounter(encounter_event)
	
func catch_monster():
	var node = enemy_party.get_child(0) as MonsterInstance
	print("Enemy children: ", enemy_party.get_children())
	print("Catching: ", node)
	var caught = PlayerMonster.create_player_monster(node)
	monster_caught.emit(caught)
