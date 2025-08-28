extends Node

@export var test_monster_data : MonsterData
@export var test_monster_instance : MonsterInstance


var caught_monsters : Array[PlayerMonster] = []
var player_party : Array[PlayerMonster] = []

func _ready():
	pass

func add_monster_to_caught_monsters(caught):
	caught_monsters.append(caught)
	if player_party.size() < 6:
		player_party.append(caught)
	
func save_game():
	pass
	
func load_game():
	pass
