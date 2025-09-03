class_name MovesComponent extends Node

signal move_gained(move_gained : Move, move_lost : Move)

var moveset : Array[Move] = []

func setup_moves_from_data(monster_data: MonsterData, current_level: int):
	var temp_learnset := []
	for i in range(monster_data.learnable_moves.size()):
		if monster_data.learn_levels[i] <= current_level:
			temp_learnset.append(monster_data.learnable_moves[i])
		
	for i in range(4):
		if !temp_learnset.is_empty():
			moveset.append(temp_learnset.pop_back())
