extends Control

signal move_used(move: Move, user: MonsterInstance, target: MonsterInstance)
signal target_requested

# ----- Enums -----
enum TurnState { PLAYER, ENEMY, RESOLVING, ENDED }
enum FightState { DECIDING, CHOOSING_1, CHOOSING_2, RESOLVING }

# ----- Exported Nodes & Properties -----
@export var battle_scene: Node
@export_range(0, 1, 0.01) var flee_chance: float

@export_group("Nodes")
@export var ai_manager: Node

@export_group("Buttons")
@export var move_1: Button
@export var move_5: Button
@export var fight: Button

# ----- Internal State -----
var turn_queue: Array[Node] = []
var turn_actions: Array[String] = []
var items_open: bool = false
var turn_state: TurnState = TurnState.PLAYER
var fight_state: FightState = FightState.DECIDING

# ----- Ready -----
func _ready() -> void:
	move_used.connect(track_turn_actions)

# ----- Physics Update -----
func _physics_process(delta: float) -> void:
	_handle_cancel_input()

func _handle_cancel_input() -> void:
	if items_open and Input.is_action_just_pressed("no"):
		%Items.visible = false
		fight.grab_focus()
		items_open = false

	if fight_state == FightState.CHOOSING_1 and Input.is_action_just_pressed("no"):
		show_fight_options()
		turn_actions.pop_back()
		fight.grab_focus()

	if fight_state == FightState.CHOOSING_2 and Input.is_action_just_pressed("no"):
		show_first_moves()
		turn_actions.pop_back()
		move_1.grab_focus()

# ----- UI Helpers -----
func button_focus(button: Button) -> void:
	button.grab_focus()

func show_fight_options() -> void:
	fight_state = FightState.DECIDING
	%Moves1.visible = false
	%Moves2.visible = false
	%Options.visible = true
	fight.grab_focus()

func hide_fight_options() -> void:
	%Options.visible = false

func add_to_turn_queue(monster: MonsterInstance):
	turn_queue.append(monster)


func show_first_moves() -> void:
	fight_state = FightState.CHOOSING_1
	%Moves1.visible = true
	%Moves2.visible = false

func show_second_moves() -> void:
	fight_state = FightState.CHOOSING_2
	%Moves1.visible = false
	%Moves2.visible = true

# ----- Player Actions -----
func _on_fight_pressed() -> void:
	show_first_moves()
	hide_fight_options()
	move_1.grab_focus()

func _on_item_pressed() -> void:
	%Items.visible = true
	items_open = true
	%ItemList.grab_focus()

func _on_run_pressed() -> void:
	attempt_run()

func attempt_run() -> void:
	if randf() <= flee_chance:
		print("You Flee")
	else:
		print("You Fail to Flee")

# ----- Move Handling -----
func _on_move_1_pressed() -> void:
	var user : MonsterInstance = turn_queue[0]
	var move : Move = user.known_moves[0]
	var target : MonsterInstance = get_target()
	move_used.emit(move, user, target)
	print(move_used)
	if turn_queue.size() > 1:
		show_second_moves()

func _on_move_5_pressed() -> void:
	_process_move("move_5")

func _on_move_2_pressed() -> void: pass
func _on_move_3_pressed() -> void: pass
func _on_move_4_pressed() -> void: pass
func _on_move_6_pressed() -> void: pass
func _on_move_7_pressed() -> void: pass
func _on_move_8_pressed() -> void: pass

func _process_move(move_name: String) -> void:
	if !battle_scene.is_double:
		if fight_state == FightState.CHOOSING_1:
			move_used.emit(move_name)
			fight_state = FightState.RESOLVING
			get_ai_move()
	else:
		if fight_state == FightState.CHOOSING_1:
			get_target()
			move_used.emit(move_name)
			show_second_moves()
			%Moves2/Move5.grab_focus()
		elif fight_state == FightState.CHOOSING_2:
			move_used.emit(move_name)
			get_ai_move()

func get_target() -> Node:
	var enemy_party = get_node_or_null("/root/Game/EnemyParty")
	return enemy_party.get_child(0)

func track_turn_actions(move_name: String) -> void:
	turn_actions.append(move_name)
	print(turn_actions)

# ----- AI Integration -----
func get_ai_move() -> void:
	print(turn_state, "get ai move")
	ai_manager.get_ai_moves()
	turn_actions.clear()
	show_fight_options()

# ----- Placeholder -----
func execute_turn_queue() -> void: pass
func _on_party_pressed() -> void: pass
