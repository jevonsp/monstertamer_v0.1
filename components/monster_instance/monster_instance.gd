class_name MonsterInstance
extends Node

@export var monster_data : MonsterData

var monster_name : String
var nick_name : String
var type : MonsterData.Type
var role : MonsterData.Role
var growth_rate : MonsterData.GrowthRate
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
	type = data.type
	role = data.role
	#growth_rate = data.GrowthRate

func create_monster(event : EncounterEvent = null):
	debug_print()

func get_effective_attack(move: Move) -> int:
	var main_stat = 0
	match role:
		MonsterData.Role.MELEE:
			main_stat = stats_component.current_attack
		MonsterData.Role.RANGE:
			main_stat = stats_component.current_dexterity
		MonsterData.Role.TANK:
			main_stat = (stats_component.current_defense) / 2
	return main_stat + move.damage

func level_up():
	stats_component.level += 1
	stats_component.base_hp += 5
	stats_component.base_speed += 1
	stats_component.base_attack += 1
	stats_component.base_defense += 1
	stats_component.base_dexterity += 1
	health_component.max_hp = stats_component.base_hp
	health_component.current_hp = health_component.max_hp 

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
	print("Speed: ", stats_component.current_speed)
	print("Attack: ", stats_component.current_attack)
	print("Defense: ", stats_component.current_defense)
	print("Dexterity: ", stats_component.current_dexterity)
	print("=====================")
	print("=== KNOWN MOVES ===")
	if known_moves.size() > 0:
		for i in range(known_moves.size()):
			var move = known_moves[i]
			print("Move ", i + 1, ": ", move.name, " (Damage: ", move.damage, ")")
	else:
		print("No moves learned yet")
	print("===================")
