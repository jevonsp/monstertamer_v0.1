class_name MonsterInstance
extends Node

@export var monster_data : MonsterData

var monster_name : String
var stats_component : StatsComponent
var current_level : int
var health_component : HealthComponent
var moves_component : MovesComponent
var known_moves : Array[Move]

var monster_data_interal : MonsterData

func _init():
	print("MonsterInstance created: ", self, " stack: ", get_stack())

func _ready():
	pass

func set_monster_data(data : MonsterData, level : int) -> void:
	monster_data_interal = data
	monster_name = data.species_name
	current_level = level

func create_monster(event : EncounterEvent = null):
	pass
	#debug_print()
		
func debug_print():
	# Print all stats
	print("=== MONSTER STATS ===")
	print("Level: ", stats_component.level)
	print("HP: ", stats_component.base_hp)
	print("Speed: ", stats_component.base_speed)
	print("Attack: ", stats_component.base_attack)
	print("Defense: ", stats_component.base_defense)
	print("Dexterity: ", stats_component.base_dexterity)
	print("=====================")
	print("=== KNOWN MOVES ===")
	if known_moves.size() > 0:
		for i in range(known_moves.size()):
			var move = known_moves[i]
			print("Move ", i + 1, ": ", move.name, " (Damage: ", move.damage, ")")
	else:
		print("No moves learned yet")
	print("===================")
