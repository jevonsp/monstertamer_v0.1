class_name PlayerMonster extends Resource

@export var base_data : MonsterData
var level : int = 1
var monster_name : String
var nick_name : String = ""
var max_hp : int
var current_hp : int
var experience : int = 0
var moves : Array[Move] = []

static func create_player_monster(node: MonsterInstance) -> PlayerMonster:
	var pm = PlayerMonster.new()
	pm.base_data = node.monster_data
	pm.level = node.current_level
	pm.monster_name = node.monster_name
	pm.max_hp = node.health_component.max_hp
	pm.current_hp = node.health_component.current_hp
	pm.experience = node.level_component.experience
	pm.moves = node.known_moves.duplicate()
	return pm
