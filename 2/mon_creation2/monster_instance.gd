class_name MonsterInstance extends Node

signal exp_gained(new: float)
signal lvl_gained(current_level)

@export var monster_data : MonsterData

#region Basic Stats
var species : String = ""
var image : Texture2D
var type : E.Type = E.Type.NONE
var role : E.Role = E.Role.MELEE 
#endregion
var level : int = 1
var experience : int = 0
var growth_rate_multi
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
	image = monster_data.image
	type = monster_data.type
	role = monster_data.role
	var growth_rate = monster_data.growth_rate
	growth_rate_multi = growth_multi[growth_rate]

func gain_exp(amount: int):
	experience += amount
	print(experience)
	
	while experience >= exp_to_next() and level < 100:
		level_up()

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
