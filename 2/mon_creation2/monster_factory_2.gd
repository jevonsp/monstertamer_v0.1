class_name MonsterFactory extends Node

func create_monster(monster_data : MonsterData) -> MonsterInstance:
	var monster = MonsterInstance.new()
	monster.set_data(monster_data)
	return monster
