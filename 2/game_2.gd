extends Node2D

signal is_in_battle # Testing #
@export var in_battle : bool = false # Testing #

func _ready() -> void:
	send_battle_signal()

func send_battle_signal() -> void: # Testing #
	if in_battle == true:
		is_in_battle.emit()

func _on_start_battle_pressed() -> void:
	in_battle = true
	send_battle_signal()
