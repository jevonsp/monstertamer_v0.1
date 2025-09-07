class_name MonsterFactory extends Node

func create_monster(monster_data: MonsterData, p_level: int) -> MonsterInstance:
	var monster = MonsterInstance.new()
	monster.set_data(monster_data)
	monster.set_stats(p_level)
	return monster
