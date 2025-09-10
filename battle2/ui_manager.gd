extends Node

signal moves1_hidden
signal party_requested
signal send_moves1(monster)
signal run_attempted

@export_subgroup("Nodes")
@export var battle_parent : Node2D
@export var battle : Node2D
@export var moves1 : Node2D
@export var txt_mgr : Control
@export var camera : Camera2D

enum State {HIDDEN, MAIN, MOVES1, MOVES2, PARTY}
var state = State.MAIN

func _ready() -> void:
	battle.option_pressed.connect(_on_option_pressed)
	set_process_input(false)
	set_process_unhandled_input(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("yes"):
		print(
			"YES fired in", self.name,
			"visible=", self.visible,
			"process_input=", is_processing_input(), "state=", get_parent().state)
	if txt_mgr.is_processing_input(): return
	if state == State.HIDDEN: return
	if event.is_action_pressed("no"):
		if state == State.MOVES1:
			_set_state(State.MAIN)
		elif state == State.PARTY:
			_set_state(State.MAIN)

func _set_state(new_state: State) -> void:
	battle.visible = false
	battle.set_process_input(false)
	moves1.visible = false
	moves1.set_process_input(false)
	
	state = new_state
	match state:
		State.HIDDEN:
			set_process_input(false)
		State.MOVES1:
			moves1.visible = true
			moves1.set_process_input(true)
		State.MAIN:
			battle.visible = true
			battle.set_process_input(true)
		State.PARTY:
			party_requested.emit()
			set_process_input(false)

func _battle_ready() -> void:
	
	_set_state(State.MAIN)
	
func party_closed() -> void:
	set_process_input(true)

func _on_option_pressed(button: int):
	if button == 0:  # Monsters
		_set_state(State.PARTY)
	if button == 1: # Fight
		_set_state(State.MOVES1)
	if button == 2:  # Run
		run_attempted.emit()
	if button == 3: # Items
		print("Implement Items")

func _on_move_selected(slot: int):
	print("move selected in slot ", slot)
	_set_state(State.MOVES1)
	set_process_input(false)
	
func _display_moves1(monster):
	send_moves1.emit(monster)

func _on_battle_manager_turn_completed() -> void:
	await get_tree().create_timer(0.1).timeout
	_set_state(State.MOVES1)

func _on_battle_manager_battle_complete() -> void:
	print("got signal fight done")
	_set_state(State.HIDDEN)
