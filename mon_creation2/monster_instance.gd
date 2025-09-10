class_name MonsterInstance extends Node

# For Party
signal exp_gained(new: float)
signal lvl_gained 
# For Battle
signal bat_exp_gained(new_exp: float, times_to_tween: int)
signal monster_died_with_exp(amount: int)
# For Both
signal new_hp_value(new: int) 
signal monster_died

@export var monster_data : MonsterData

#region Basic Stats
var species : String = ""
var monster_name : String = ""
var gender : E.Gender = E.Gender.MALE
var gender_icon : Texture2D
var gender_icons : Dictionary = {}
var image : Texture2D
var type : E.Type = E.Type.NONE
var role : E.Role = E.Role.MELEE 
#endregion
#region States
var is_fainted : bool = false
#endregion
#region Levels
var level : int = 1
var experience : int = 0
var exp_percent : float
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
#region Moves
var known_moves : Array[Move] = []
#endregion

func _ready() -> void:
	var parent = get_parent()
	print("parent: ", parent)
	if parent and parent.has_method("handle_monster_death"):
		monster_died.connect(parent.handle_monster_death)
#region Setting Stats
func set_data(data : MonsterData) -> void:
	monster_data = data
	species = monster_data.species
	monster_name = species
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
	var chosen = options[randi() % options.size()]
	gender_icon = gender_icons[chosen]
	return chosen

func set_gender_icon(male: Texture2D, female: Texture2D, none: Texture2D) -> void:
	gender_icons = {
		E.Gender.MALE: male, E.Gender.FEMALE: female, E.Gender.NONE: none}

func set_stats(p_level: int) -> void:
	level = p_level
	hitpoints = monster_data.base_hitpoints
	speed = monster_data.base_speed
	attack = monster_data.base_attack
	defense = monster_data.base_defense
	dexterity = monster_data.base_dexterity
	magic = monster_data.base_magic
	charm = monster_data.base_charm
	hitpoints += int(level * monster_data.hitpoints_growth)
	current_hp = hitpoints
	print("current_hp: %d" % current_hp)
	print("hitpoints: %d" % hitpoints)
	speed += int(level * monster_data.speed_growth)
	attack += int(level * monster_data.attack_growth)
	defense += int(level * monster_data.defense_growth)
	dexterity += int(level * monster_data.defense_growth)
	magic += int(level * monster_data.magic_growth)
	charm += int(level * monster_data.charm_growth)
	experience = exp_to_level(level)
	
func set_moves():
	known_moves.clear()
	var move_set : Array[Move] = []
	for i in range(monster_data.levels.size()):
		if monster_data.levels[i] <= level:
			move_set.append(monster_data.moves[i])
	if move_set.size() > 4:
		move_set = move_set.slice(move_set.size() - 4, 4)
	known_moves = move_set.duplicate()
	var known_moves_names : Array[String]
	for move in known_moves:
		known_moves_names.append(move.move_name)
	print(known_moves_names)
#endregion

#region Exp Gain
func exp_to_level(p_level):
	const BASE = 100
	return BASE * pow(p_level - 1, 2)
	
func gain_exp(amount: int):
	experience += amount
	var times_to_level := 0
	while experience >= exp_to_level(level + 1):
		level_up()
		times_to_level += 1
	var percent = get_exp_percent()
	exp_percent = percent
	exp_gained.emit(percent)
	bat_exp_gained.emit(get_exp_percent(), times_to_level)

func get_exp_percent():
	var curr_level_exp = exp_to_level(level)
	var next_level_exp = exp_to_level(level + 1)
	var exp_into_level = experience - curr_level_exp
	var exp_needed = next_level_exp - curr_level_exp
	return float(exp_into_level) / float(exp_needed) * 100

func level_up():
	level += 1
	lvl_gained.emit()
	print("emitted lvl_gained")
#endregion

#region Damage
func lose_life(target: MonsterInstance, amount: int):
	if target == self:
		current_hp -= amount
		current_hp = max(current_hp, 0)
		new_hp_value.emit(current_hp)
	if current_hp == 0:
		is_fainted = true
		monster_died.emit(self)

func gain_life(target: MonsterInstance, amount: int):
	if target == self:
		current_hp += amount
		current_hp = min(current_hp, hitpoints)
		new_hp_value.emit(current_hp)
#endregion
