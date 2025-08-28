extends Node

signal enemy_move(string: String)

@export var battle_scene : Node2D

func get_ai_moves():
	var move = randi_range(1,4)
	if !battle_scene.is_double:
		print("monster used move" + str(move)) 
		print("on your monster")
	else:
		print("monster used move" + str(move))
		print("on monster" + str(get_ai_targets()))
	
func get_ai_targets():
	return randi_range(1,2)
