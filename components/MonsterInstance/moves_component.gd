class_name MovesComponent extends Resource

signal move_gained(move_gained : Move, move_lost : Move)

var moveset : Array[Move] = []

func setup_moves_from_data(event: EncounterEvent):
	var temp_learnset := []
	for move in event.monster_data.learnable_moves:
		temp_learnset.append(move)
	for i in range(4):
		if !temp_learnset.is_empty():
			moveset.append(temp_learnset.pop_back())
		
