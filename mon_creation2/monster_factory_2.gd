class_name MonsterFactory extends Node

@export_subgroup("Gender Icons")
@export var male_icon : Texture2D
@export var female_icon : Texture2D
@export var none_icon : Texture2D

func create_monster(monster_data: MonsterData, p_level: int) -> MonsterInstance:
	var monster = MonsterInstance.new()
	# Can set more data here like type images
	monster.set_gender_icon(male_icon, female_icon, none_icon)
	# Now we setup the monster
	monster.set_data(monster_data)
	monster.set_stats(p_level)
	monster.set_moves()
	print("monster known moves after set_moves:", monster.known_moves)
	return monster
