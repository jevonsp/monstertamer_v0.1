class_name MonsterInstance
extends Node

@export var monster_data : MonsterData

var stats_component : StatsComponent
var current_level : int
var moves_component : MovesComponent
var known_moves : Array[Move]

func _ready() -> void:
	create_monster()
	
func create_monster():
	stats_component = StatsComponent.new()
	moves_component = MovesComponent.new()
	
	var encounter = EncounterEvent.new(monster_data, 1)
	stats_component.setup_monster_from_data(encounter)
	moves_component.setup_moves_from_data(encounter.monster_data)
	
	# Print all stats
	print("=== MONSTER STATS ===")
	print("Level: ", stats_component.level)
	print("HP: ", stats_component.base_hp)
	print("Speed: ", stats_component.base_speed)
	print("Attack: ", stats_component.base_attack)
	print("Defense: ", stats_component.base_defense)
	print("Dexterity: ", stats_component.base_dexterity)
	print("=====================")
	
	known_moves = moves_component.moveset.duplicate()
	
	print("=== KNOWN MOVES ===")
	if known_moves.size() > 0:
		for i in range(known_moves.size()):
			var move = known_moves[i]
			print("Move ", i + 1, ": ", move.name, " (Damage: ", move.damage, ")")
	else:
		print("No moves learned yet")
	print("===================")
