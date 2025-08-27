extends Control

signal move_used(string: String)

@export var battle_scene:  Node
@export_subgroup("Debug Properties")
@export_range(0, 1, .01) var flee_chance

@export_subgroup("Buttons")
@export var move_1 : Button
@export var move_5 : Button
@export var fight : Button

#signal move_used(move: Move, user: MonsterInstance, target: MonsterInstance)

var items_open : bool = false

enum TurnState {
	PLAYER,
	ENEMY,
	RESOLVING,
	ENDED
}
var turn_state : TurnState = TurnState.PLAYER

enum FightState {
	DECIDING,
	CHOOSING_1,
	CHOOSING_2,
	RESOLVING
}
var fight_state : FightState = FightState.DECIDING

var turn_queue : Array[Node] = []
var turn_actions: Array[String] = []

func _ready() -> void:
	# This connects the button pushed signal to a turn action tracker
	move_used.connect(track_turn_actions)

func _physics_process(delta: float) -> void:
	if items_open and Input.is_action_just_pressed("no"):
		%Items.visible = false
		fight.grab_focus()
	if fight_state == FightState.CHOOSING_1 and Input.is_action_just_pressed("no"):
		show_fight_options()
		turn_actions.pop_back()
		fight.grab_focus()
	if fight_state == FightState.CHOOSING_2 and Input.is_action_just_pressed("no"):
		show_first_moves()
		turn_actions.pop_back()
		move_1.grab_focus()

func button_focus(button: Button):
	button.grab_focus()

func _on_fight_pressed() -> void:
	show_first_moves()
	hide_fight_options()
	move_1.grab_focus()

func _on_item_pressed() -> void:
	%Items.visible = true
	items_open = true
	%ItemList.grab_focus()

func track_turn_actions(string):
	turn_actions.append(string)
	print(turn_actions)

func show_fight_options() -> void:
	fight_state = FightState.DECIDING
	%Moves1.visible = false
	%Moves2.visible = false
	%Options.visible = true
	fight.grab_focus()
	print(fight_state)
	
func hide_fight_options() -> void:
	%Options.visible = false

func _on_move_1_pressed() -> void:
	if !battle_scene.is_double and FightState.CHOOSING_1:
		move_used.emit("move_1")
		get_ai_move()
	else:
		# Targeting would go here
		move_used.emit("move_1")
		show_second_moves()
		%Moves2/Move5.grab_focus()
		
func _on_move_2_pressed() -> void:
	if !battle_scene.is_double and FightState.CHOOSING_1:
		move_used.emit("move_2")
		get_ai_move()
	else:
		move_used.emit("move_2")
		show_second_moves()
		%Moves2/Move5.grab_focus()

func _on_move_3_pressed() -> void:
	if !battle_scene.is_double and FightState.CHOOSING_1:
		move_used.emit("move_3")
		get_ai_move()
	else:
		move_used.emit("move_3")
		show_second_moves()
		%Moves2/Move5.grab_focus()

func _on_move_4_pressed() -> void:
	if !battle_scene.is_double and FightState.CHOOSING_1:
		move_used.emit("move_4")
		get_ai_move()
	else:
		move_used.emit("move_4")
		show_second_moves()
		%Moves2/Move5.grab_focus()
	
func show_first_moves() -> void:
	fight_state = FightState.CHOOSING_1
	print(fight_state)
	%Moves1.visible = true
	%Moves2.visible = false
	
func show_second_moves() -> void:
	fight_state = FightState.CHOOSING_2
	%Moves1.visible = false
	%Moves2.visible = true

func _on_move_5_pressed() -> void:
	# Targeting would go here
	move_used.emit("move_5")
	fight_state = FightState.RESOLVING
	get_ai_move()
	 
func _on_move_6_pressed() -> void:
	move_used.emit("move_6")
	fight_state = FightState.RESOLVING
	get_ai_move()

func _on_move_7_pressed() -> void:
	move_used.emit("move_7")
	fight_state = FightState.RESOLVING
	get_ai_move()

func _on_move_8_pressed() -> void:
	move_used.emit("move_8")
	fight_state = FightState.RESOLVING
	get_ai_move()

func get_ai_move():
	turn_state = TurnState.ENEMY
	print(turn_state)
	print("get ai move")
	turn_actions.clear()
	show_fight_options()

func _on_party_pressed() -> void:
	pass

func _on_run_pressed() -> void:
	attempt_run()

func attempt_run() -> void:
	if randf() <= flee_chance:
		print("You Flee")
	else:
		print("You Fail to Flee")
