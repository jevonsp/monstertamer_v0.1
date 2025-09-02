extends Node2D

@export_subgroup("Nodes")
@export var player : CharacterBody2D
@export var party : Node
@export var enemy_party : Node
@export var capture_mgr : Node
@export var storage_mgr : Node
@export var txt_pnl : Node
@export var camera : Camera2D
@export_subgroup("Node Arrays")
@export var singles_ui : Array[Node]
@export var doubles_ui : Array[Node]
@export var constant_ui : Array[Node]
@export_subgroup("VBoxes")
@export var player_box1 : VBoxContainer
@export var player_box2 : VBoxContainer
@export var enemy_box1 : VBoxContainer
@export var enemy_box2 : VBoxContainer
@export_subgroup("HBoxes")
@export var player_container : HBoxContainer
@export var enemy_container : HBoxContainer
@export_subgroup("Monster Texture")
@export var player_texture1 : TextureRect
@export var player_texture2 : TextureRect
@export var enemy_texture1 : TextureRect
@export var enemy_texture2 : TextureRect
@export_subgroup("Monster Names")
@export var player_name1 : Label
@export var player_name2 : Label
@export var enemy_name1 : Label
@export var enemy_name2 : Label

var turn_queue : Array[Node] = []
var is_single : bool = true
# These are Turn Queue Entries
var player_monster1 : Node
var player_monster2 : Node
var enemy_monster1 : Node
var enemy_monster2 : Node

var hp_bar_scene = preload("res://main_scenes/battle/progress_bar.tscn")

func _ready() -> void:
	pass

func _on_enemy_party_monsters_ready() -> void:
	enter_battle()
	setup_battle()
	start_battle()

func enter_battle():
	self.visible = true
	flip_physics_process(false)
	flip_camera()

func setup_battle():
	make_turn_queue()
	sort_turn_queue()
	display_monsters()
	show_health_bars()
	setup_moves()
	flip_ui_visibility(true)
	
func flip_physics_process(enable: bool):
	print("stop movement here")
	player.set_physics_process(enable)
func flip_camera():
	if camera.is_current():
		player.camera.make_current()
	else:
		camera.make_current()
func flip_ui_visibility(enable: bool):
	set_ui_visible(constant_ui, enable)
	if !is_single:
		set_ui_visible(doubles_ui, enable)
	else:
		set_ui_visible(singles_ui, enable)
func set_ui_visible(ui_group: Array[Node], show: bool):
	for element in ui_group:
		element.visible = show

func make_turn_queue():
	if is_single:
		make_singles_queue()
	else:
		make_doubles_queue()
func make_singles_queue():
	player_monster1 = party.party_slots[0].node
	player_monster1.set_meta("ui_box", player_box1)
	player_monster1.set_meta("texture_rect", player_texture1)
	player_monster1.set_meta("name_label", player_name1)
	turn_queue.append(player_monster1)
	
	enemy_monster1 = enemy_party.get_child(0)
	enemy_monster1.set_meta("ui_box", enemy_box1)
	enemy_monster1.set_meta("texture_rect", enemy_texture1)
	enemy_monster1.set_meta("name_label", enemy_name1)
	turn_queue.append(enemy_monster1)
func make_doubles_queue():
	player_monster1 = party.party_slots[0].node
	player_monster1.set_meta("ui_box", player_box1)
	player_monster1.set_meta("texture_rect", player_texture1)
	player_monster1.set_meta("name_label", player_name1)
	turn_queue.append(player_monster1)
	
	enemy_monster1 = enemy_party.get_child(0)
	enemy_monster1.set_meta("ui_box", enemy_box1)
	enemy_monster1.set_meta("texture_rect", enemy_texture1)
	enemy_monster1.set_meta("name_label", enemy_name1)
	turn_queue.append(enemy_monster1)
	
	player_monster2 = party.party_slots[1].node
	player_monster2.set_meta("ui_box", player_box2)
	player_monster2.set_meta("texture_rect", player_texture2)
	player_monster2.set_meta("name_label", player_name2)
	turn_queue.append(player_monster2)
	
	enemy_monster2 = enemy_party.get_child(1)
	enemy_monster2.set_meta("ui_box", enemy_box2)
	enemy_monster2.set_meta("texture_rect", enemy_texture2)
	enemy_monster2.set_meta("name_label", enemy_name2)
	turn_queue.append(enemy_monster2)
func sort_turn_queue():
	turn_queue.sort_custom(
		func(a ,b): return a.stats_component.current_speed > b.stats_component.current_speed)

func display_monsters():
	for node in turn_queue:
		pass
	
	if !is_single:
		if player_monster1:
			player_texture1.texture = player_monster1.monster_data.texture
			player_name1.text = player_monster1.monster_data.species_name
		if enemy_monster1:
			enemy_texture1.texture = enemy_monster1.monster_data.texture
			enemy_name1.text = enemy_monster1.monster_data.species_name
		if player_monster2:
			player_texture2.texture = player_monster2.monster_data.texture
			player_name2.text = player_monster2.monster_data.species_name
		if enemy_monster2:
			enemy_texture2.texture = enemy_monster2.monster_data.texture
			enemy_name2.text = enemy_monster2.monster_data.species_name
	else:
		if player_monster1:
			player_texture1.texture = player_monster1.monster_data.texture
			player_name1.text = player_monster1.monster_data.species_name
		if enemy_monster1:
			enemy_texture1.texture = enemy_monster1.monster_data.texture
			enemy_name1.text = enemy_monster1.monster_data.species_name
func show_health_bars():
	for node in turn_queue:
		if not node.has_meta("HPBar"):
			var bar = hp_bar_scene.instantiate()
			if node == player_monster1:
				player_box1.add_child(bar)
			elif node == player_monster2:
				player_box2.add_child(bar)
			elif node == enemy_monster1:
				enemy_box1.add_child(bar)
			elif node == enemy_monster2:
				enemy_box2.add_child(bar)
			
			bar.bind_to_monster(node)
			node.set_meta("HPBar", bar)

func setup_moves():
	pass

func start_battle():
	print("battle ok to start")

func _on_on_pressed() -> void:
	flip_ui_visibility(true)
func _on_off_pressed() -> void:
	flip_ui_visibility(false)
