extends Node

signal monsters_ready

var monster_data_array : Array[MonsterData] = []

@export var monster_factory : Node

# connect all encounter zones through signals
func add_monster(event):
	var monster = monster_factory.create_from_encounter(event)
	add_child(monster)
	print("monster ready")
	monsters_ready.emit()
	
func add_trainer_monsters(trainer_party: Array):
	for i in trainer_party:
		var event = trainer_party[i]
		var trainer_monster = monster_factory.create_from_encounter(event)
		add_child(trainer_monster)
	monsters_ready.emit()
