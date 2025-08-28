class_name StatsComponent extends Resource

signal stat_changed(stat_name: String, new_value: int)

@export_subgroup("Stats")
@export var level : int
@export var base_hp : int
@export var base_speed : int
@export var base_attack : int
@export var base_defense : int
@export var base_dexterity : int

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
	
# These types in battle
func get_effective_attack():
	pass
