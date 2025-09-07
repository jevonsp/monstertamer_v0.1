class_name MonsterInstance extends Node

signal exp_gained(new: float)
signal lvl_gained(current_level)

@export var monster_data : MonsterData

#region Basic Stats
var species : String = ""
var gender : E.Gender
var image : Texture2D
var type : E.Type = E.Type.NONE
var role : E.Role = E.Role.MELEE 
#endregion
#region Levels
var level : int = 1
var experience : int = 0
var growth_rate_multi
#endregion
#region Stats
var hitpoints : int = 0
var current_hp : int = 0
var speed : int = 0
var attack : int = 0
var defense : int = 0
var dexterity : int = 0
var magic : int = 0
var charm : int = 0
#endregion
#region Growth Rate Dict 
var growth_multi : Dictionary = {
	E.GrowthRate.SLOWEST: 1.4,
	E.GrowthRate.SLOW: 1.2,
	E.GrowthRate.MEDIUM: 1.0, # 100% (normal)
	E.GrowthRate.FAST: 0.8,
	E.GrowthRate.FASTEST: .6 }
#endregion

func _ready() -> void:
	pass

func set_data(data : MonsterData) -> void:
	monster_data = data
	species = monster_data.species
	gender = pick_random_gender(monster_data.allowed_genders)
	print("Spawned", species, "with gender", gender)
	image = monster_data.image
	type = monster_data.type
	role = monster_data.role
	var growth_rate = monster_data.growth_rate
	growth_rate_multi = growth_multi[growth_rate]

func pick_random_gender(mask: int) -> E.Gender:
	var options: Array = []
	if mask & E.Gender.MALE != 0:
		options.append(E.Gender.MALE)
	if mask & E.Gender.FEMALE != 0:
		options.append(E.Gender.FEMALE)
	if mask & E.Gender.NONE != 0:
		options.append(E.Gender.NONE)
	if options.size() == 0:
		return E.Gender.NONE
	return options[randi() % options.size()]

func set_stats(p_level: int) -> void:
	level = p_level
	hitpoints = monster_data.base_hitpoints
	speed = monster_data.base_speed
	attack = monster_data.base_attack
	defense = monster_data.base_defense
	dexterity = monster_data.base_dexterity
	magic = monster_data.base_magic
	charm = monster_data.base_charm
	hitpoints += level * monster_data.hitpoints_growth
	current_hp = hitpoints
	print("current_hp: %d" % current_hp)
	print("hitpoints: %d" % hitpoints)
	speed += level * monster_data.speed_growth
	attack += level * monster_data.attack_growth
	defense += level * monster_data.defense_growth
	dexterity += level * monster_data.defense_growth
	magic += level * monster_data.magic_growth
	charm += level * monster_data.charm_growth
	experience = exp_to_level(level)
	
func gain_exp(amount: int):
	pass

func exp_to_level(p_level):
	const BASE = 100
	return BASE * pow(p_level - 1, 2)
	
func exp_to_next():
	return exp_to_level(level + 1)
	
func print_percent():
	var percent
	print("percent through level: " + percent)
	
func level_up():
	level += 1
	print(level)
	lvl_gained.emit(level)
