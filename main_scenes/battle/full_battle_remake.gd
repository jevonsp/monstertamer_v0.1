extends Node2D

signal is_in_battle
@export var in_battle : bool = false

func _ready() -> void:
	send_battle_signal()

func send_battle_signal() -> void:
	if in_battle == true:
		is_in_battle.emit()
