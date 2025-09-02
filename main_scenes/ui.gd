extends Node

@export var menu_list : Node2D
@export var party_list : Node2D
@export var player : CharacterBody2D

var in_battle : bool = false
var in_menu : bool = false

func _ready() -> void:
	menu_list.visible = false
	party_list.visible = false

func _input(event: InputEvent) -> void:
	if !in_menu:
		if event.is_action_pressed("menu") and !in_battle:
			menu_list.visible = true
			menu_list.set_process_input(true)
			player.set_process_input(false)
			player.set_physics_process(false)
			in_menu = true
	else:
		if event.is_action_pressed("menu") and !in_battle:
			menu_list.visible = false
			menu_list.set_process_input(false)
			player.set_process_input(true)
			player.set_physics_process(true)
			in_menu = false

func _on_battle_scene_3_now_in_battle() -> void:
	in_battle = true

func _on_battle_scene_3_ending_battle() -> void:
	in_battle = false
