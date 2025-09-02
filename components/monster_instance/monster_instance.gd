class_name MonsterInstance
extends Node

@export var monster_data : MonsterData

var monster_name : String
var nick_name : String
var stats_component : StatsComponent
var current_level : int
var health_component : HealthComponent
var current_hp : int
var moves_component : MovesComponent
var moves : Array[Move] = []
var known_moves : Array[Move]
var battle_scene : Node
var experience : int = 0
var level : int = 1

func _ready():
	pass

func set_monster_data(data : MonsterData, level : int) -> void:
	monster_data = data
	monster_name = data.species_name
	current_level = level

func create_monster(event : EncounterEvent = null):
	pass
	#debug_print()

func add_to_turn_queue():
	if health_component == null:
		push_error("Monster missing health_component: %s" % name)
		return
	# Setup HP bar if missing
	if not has_meta("HPBar"):
		push_error("no meta!")
	
	battle_scene.turn_queue.append(self)

func debug_print():
	# Print all stats
	print("=== MONSTER STATS ===")
	print("Level: ", stats_component.level)
	print("HP: ", stats_component.base_hp)
	print("Current HP: ", health_component.current_hp)
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
