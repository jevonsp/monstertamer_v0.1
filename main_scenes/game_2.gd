extends Node2D

signal is_in_battle # Testing #
@export var in_battle : bool = false # Testing #

func send_battle_signal() -> void: # Testing #
	if in_battle == true:
		is_in_battle.emit()
