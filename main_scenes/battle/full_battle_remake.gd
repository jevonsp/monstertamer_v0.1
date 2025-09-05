extends Node2D

signal is_in_battle
@export var in_battle : bool = false

func _ready() -> void:
	visible = false
	send_battle_signal()

func _show_subscenes():
	for child in get_children():
		child.visible = true
func _hide_subscenes():
	for child in get_children():
		child.visible = false

func check_visibility():
	await get_tree().process_frame

func send_battle_signal() -> void:
	if in_battle == true:
		is_in_battle.emit()
