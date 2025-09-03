extends Control

@export_subgroup("Node Containers")
@export var main_buttons : GridContainer
@export var move_buttons1 : GridContainer
@export var move_buttons2 : GridContainer
#@export_subgroup("Nodes")

var last_main_used : Button
var last_move1_used : Button
var last_move2_used : Button

enum ChoiceState {MAIN, CHOICE1, CHOICE2}
var choice_state = ChoiceState.MAIN

func _ready() -> void:
	for button in get_tree().get_nodes_in_group("main_buttons"):
		button.connect("pressed", Callable(self, "track_main_pressed").bind(button))
	for button in get_tree().get_nodes_in_group("move1_buttons"):
		button.connect("pressed", Callable(self, "track_buttons1_pressed").bind(button))
	for button in get_tree().get_nodes_in_group("move2_buttons"):
		button.connect("pressed", Callable(self, "track_buttons2_pressed").bind(button))

func buttons_off(enable: bool):
	for button in main_buttons.get_children():
		button.disabled = enable
	for button in move_buttons1.get_children():
		button.disabled = enable
	for button in move_buttons2.get_children():
		button.disabled = enable

func show_button_state(state: ChoiceState):
	main_buttons.visible = false
	move_buttons1.visible = false
	move_buttons2.visible = false
	match state:
		ChoiceState.MAIN:
			main_buttons.visible = true
			if last_main_used != null:
				last_main_used.grab_focus()
			else:
				main_buttons.get_child(1).grab_focus()
		ChoiceState.CHOICE1:
			move_buttons1.visible = true
			if last_move1_used != null:
				last_move1_used.grab_focus()
			else:
				move_buttons1.get_child(0).grab_focus()
		ChoiceState.CHOICE2:
			move_buttons2.visible = true
			if last_move2_used != null:
				last_move2_used.grab_focus()
			else:
				move_buttons2.get_child(0).grab_focus
	choice_state = state

func track_main_pressed(button: Button) -> void:
	last_main_used = button

func track_buttons1_pressed(button: Button) -> void:
	last_move1_used = button

func track_buttons2_pressed(button: Button) -> void:
	last_move2_used = button

func _move_back_pressed():
	if choice_state == ChoiceState.CHOICE1:
		show_button_state(ChoiceState.MAIN)
	elif choice_state == ChoiceState.CHOICE2:
		show_button_state(ChoiceState.CHOICE1)
