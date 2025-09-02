extends Node

@export var menu_list : Node2D
@export var party_list : Node2D
@export var player : CharacterBody2D

var in_battle : bool = false
var in_menu : bool = false
var in_party : bool = false

func _ready() -> void:
	_set_ui_state(menu_list, false)
	_set_ui_state(party_list, false)
	menu_list.party_selected.connect(_on_party_selected)
	menu_list.invent_selected.connect(_on_invent_selected)
	menu_list.save_selected.connect(_on_save_selected)
	menu_list.closed.connect(_on_menu_closed)
	party_list.closed.connect(_on_party_closed)
 
func _input(event: InputEvent) -> void:
	if in_battle: return
	if event.is_action_pressed("menu"): 
		if in_menu: hide_menu()
		else: show_menu()

func show_menu():
	_set_ui_state(menu_list, true)
	_set_player_state(false)
	in_menu = true
func hide_menu():
	_set_ui_state(menu_list, false)
	_set_player_state(true)
	in_menu = false
func show_party():
	_set_ui_state(menu_list, false)
	_set_ui_state(party_list, true)
	in_party = true

func _on_menu_closed(): hide_menu()
func _on_party_selected(): show_party()
func _on_party_closed():
	_set_ui_state(party_list, false)
	show_menu()
	in_party = false

func _on_invent_selected(): print("Todo: Invent")
func _on_save_selected(): print("Todo: Save")

func _set_ui_state(node: Node2D, active: bool) -> void:
	node.visible = active
	node.set_process_input(active)
func _set_player_state(active: bool) -> void:
	player.set_physics_process(active)
	player.set_process_input(active)

func _on_battle_scene_3_now_in_battle() -> void:
	in_battle = true

func _on_battle_scene_3_ending_battle() -> void:
	in_battle = false
