class_name StatsComponent extends Resource

signal stat_changed(stat_name: String, new_value: int)

@export_subgroup("Stats")
@export var level : int
@export var base_hp : int
@export var base_speed : int
@export var base_attack : int
@export var base_defense : int
@export var base_dexterity : int

var current_speed : int
var current_attack : int
var current_defense : int
var current_dexterity : int

# Called when a monster is made
func setup_monster_from_data(event : EncounterEvent):
	if !event or !event.monster_data:
		return
	level = event.level
	base_hp = event.monster_data.base_hp
	base_speed = event.monster_data.base_speed
	base_attack = event.monster_data.base_attack
	base_defense = event.monster_data.base_defense
	base_dexterity = event.monster_data.base_dexterity
	current_speed = base_speed
	current_attack = base_attack
	current_defense = base_defense
	current_dexterity = base_dexterity

func setup_monster_from_pm(pm: PlayerMonster):
	level = pm.level
	base_hp = pm.base_data.base_hp
	base_attack = pm.base_data.base_attack
	base_defense = pm.base_data.base_defense
	base_speed = pm.base_data.base_speed
	base_dexterity = pm.base_data.base_dexterity

func change_stats(stat, amount):
	pass
