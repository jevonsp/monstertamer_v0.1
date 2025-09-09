extends Node

signal moves1_hidden
signal party_requested

@export_subgroup("Nodes")
@export var battle : Node2D
@export var moves1 : Node2D
@export var txt_mgr : Control

enum State {MAIN, MOVES1, MOVES2}
var state = State.MAIN

func _ready() -> void:
	battle.option_pressed.connect(_on_option_pressed)

func _input(event: InputEvent) -> void:
	if txt_mgr.is_processing_input(): return
	if event.is_action_pressed("no"):
		var transitions = {
			State.MOVES1: func(): _hide_moves1(),
			State.MAIN: func(): pass}
		if state in transitions:
			transitions[state].call()

func _on_option_pressed(button: int):
	if button == 0: _show_party()
	if button == 1: _show_moves1()

func _set_ui_state(node: Node2D, active: bool) -> void:
	print("UI manager: set_ui_state called on ", node.name, " with active=", active)
	node.visible = active
	node.set_process_input(active)
	
func _show_moves1():
	_set_ui_state(battle, false)
	_set_ui_state(moves1, true)
	state = State.MOVES1

func _hide_moves1():
	_set_ui_state(moves1, false)
	_set_ui_state(battle, true)
	state = State.MAIN
	moves1_hidden.emit()

func _show_party():
	_disable_control()
	party_requested.emit()

func _hide_party():
	_enable_control()

func _enable_control() -> void:
	battle.set_process_input(true)
	
func _disable_control() -> void:
	battle.set_process_input(false)

func _on_battle_manager_turn_completed() -> void:
	await get_tree().create_timer(0.1).timeout
	_show_moves1()
