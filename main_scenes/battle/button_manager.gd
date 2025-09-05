extends Node

@export_subgroup("Nodes")
@export var battle : Node2D
@export var moves1 : Node2D

enum State {MAIN, MOVES1, MOVES2}
var state = State.MAIN

func _ready() -> void:
	battle.option_pressed.connect(_on_option_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("no") and state == State.MOVES1:
		_hide_moves1()

func _on_option_pressed(button: int):
	if button == 1 and state == State.MAIN:
		_show_moves1()

func _set_ui_state(node: Node2D, active: bool) -> void:
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
	
