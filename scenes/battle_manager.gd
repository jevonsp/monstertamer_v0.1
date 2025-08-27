extends Node
@export var battle_scene:  Node

#signal move_used(move: Move, user: MonsterInstance, target: MonsterInstance)
signal move_used(string: String)

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

func _physics_process(delta: float) -> void:
	if items_open and Input.is_action_just_pressed("no"):
		%Items.visible = false
		%Options.grab_focus()
	if fight_state == FightState.CHOOSING_2 and Input.is_action_just_pressed("no"):
		hide_second_moves()
	
func _on_fight_pressed() -> void:
	fight_state = FightState.CHOOSING_1
	%Options.visible = false
	%Moves1.visible = true
	%Moves1.grab_focus()

func _on_item_pressed() -> void:
	%Items.visible = true
	items_open = true
	%ItemList.grab_focus()

func _on_move_1_pressed() -> void:
	if !battle_scene.is_double and FightState.CHOOSING_1:
		print("move_1")
		move_used.emit("1")
		%Moves1.visible = false
		%Options.visible = true
		%Options/Fight.grab_focus()
	else:
		fight_state = FightState.CHOOSING_2
		show_second_moves()
		
func _on_move_2_pressed() -> void:
	move_used.emit("2")

func _on_move_3_pressed() -> void:
	move_used.emit("3")

func _on_move_4_pressed() -> void:
	move_used.emit("4")

func show_second_moves() -> void:
	%Moves1.visible = false
	%Moves2.visible = true
	
func hide_second_moves() -> void:
	%Moves1.visible = true
	%Moves2.visible = false
	
func _on_move_5_pressed() -> void:
	move_used.emit("5")

func _on_move_6_pressed() -> void:
	move_used.emit("6")

func _on_move_7_pressed() -> void:
	move_used.emit("7")

func _on_move_8_pressed() -> void:
	move_used.emit("8")

func _on_party_pressed() -> void:
	move_used.emit()

func _on_run_pressed() -> void:
	move_used.emit()
