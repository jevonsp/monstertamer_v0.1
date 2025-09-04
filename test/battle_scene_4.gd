extends Node2D

signal now_in_battle
signal ending_battle
signal attack_happened(user, target, move, damage)
signal turn_complete

@export_subgroup("Nodes")
@export var player : CharacterBody2D
@export var party : Node
@export var enemy_party : Node
@export var capture_mgr : Node
@export var storage_mgr : Node
@export var txt_mgr : Node
@export var ui_mgr : Control
@export var tqm_mgr : Node
@export var mui_binder : Node
@export var battle_calc : Node
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
@export_subgroup("Buttons")
@export var main_buttons : GridContainer
@export var move_buttons1 : GridContainer
@export var move_buttons2 : GridContainer
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

var hold_timer = 0.0
var hold_limit = 2.5

var turn_queue : Array[Node] = []
var is_single : bool = true
# These are Turn Queue Entries
var player_monster1 : Node
var player_monster2 : Node
var enemy_monster1 : Node
var enemy_monster2 : Node

var known_moves1 : Array[Move]
var known_moves2 : Array[Move]

var turn_actions : Array[TurnAction]

var hp_bar_scene = preload("res://main_scenes/battle/progress_bar.tscn")

func _ready() -> void:
	randomize()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("no"):
		ui_mgr._move_back_pressed()
		
func _process(delta: float) -> void:
	if Input.is_action_pressed("no") and ui_mgr.choice_state == ui_mgr.ChoiceState.MAIN:
		hold_timer += delta
		if hold_timer > hold_limit:
			print("Held Run")
			hold_timer = 0.0
			end_battle()
	else:
		hold_timer = 0.0

func _on_enemy_party_monsters_ready() -> void:
	now_in_battle.emit()
	enter_battle()
	setup_battle()
	start_battle()

func enter_battle():
	self.visible = true
	flip_physics_process(false)
	flip_camera()
	ui_mgr.show_button_state(ui_mgr.ChoiceState.MAIN)
func setup_battle():
	make_turn_queue() # can split out
	sort_turn_queue() # can split out
	display_monsters()
	show_health_bars()
	setup_moves()
	flip_ui_visibility(true)
	main_buttons.get_child(1).grab_focus()
	
func start_battle():
	pass

func flip_physics_process(enable: bool):
	print("stop/start movement here")
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

func _on_enemy_party_is_double() -> void:
	is_single = false
func make_turn_queue():
	if is_single:
		make_singles_queue()
	else:
		make_doubles_queue()
func make_singles_queue():
	# moved to tqm
	player_monster1 = party.party_slots[0].node
	# need to move to monsteruibinder
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
	turn_queue.sort_custom(Callable(self, "compare_speed"))
	for monster in turn_queue:
		monster.participated = true
func compare_speed(a, b): # Helper
	return b.stats_component.current_speed - a.stats_component.current_speed

func display_monsters():
	for node in turn_queue:
		pass
	
	if !is_single:
		if player_monster1:
			player_texture1.texture = player_monster1.monster_data.texture
			player_name1.text = player_monster1.monster_name
		if enemy_monster1:
			enemy_texture1.texture = enemy_monster1.monster_data.texture
			enemy_name1.text = enemy_monster1.monster_name
		if player_monster2:
			player_texture2.texture = player_monster2.monster_data.texture
			player_name2.text = player_monster2.monster_name
		if enemy_monster2:
			enemy_texture2.texture = enemy_monster2.monster_data.texture
			enemy_name2.text = enemy_monster2.monster_name
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

func replace_monster(old: MonsterInstance, new: MonsterInstance):
	if old == player_monster1:
		new = player_monster1
	elif old == player_monster2:
		new = player_monster2
	sort_turn_queue()
	setup_moves()

func setup_moves():
	if player_monster1:
		known_moves1 = player_monster1.known_moves
		var buttons1 = move_buttons1.get_children()
		for i in range(min(buttons1.size(), known_moves1.size())):
			var move = known_moves1[i]
			var btn = buttons1[i]
			btn.text = move.name
			btn.set_meta("user", player_monster1)
			btn.set_meta("move", move)
			if not btn.pressed.is_connected(_on_move_pressed):
				btn.pressed.connect(_on_move_pressed.bind(btn))
	if player_monster2:
		var known_moves2 = player_monster2.known_moves
		var buttons2 = move_buttons2.get_children()
		for i in range(min(buttons2.size(), known_moves2.size())):
			var move = known_moves2[i]
			var btn = buttons2[i]
			btn.text = move.name
			btn.set_meta("user", player_monster2)
			btn.set_meta("move", move)
			if not btn.pressed.is_connected(_on_move_pressed):
				btn.pressed.connect(_on_move_pressed.bind(btn))

func _on_fight_pressed() -> void:
	ui_mgr.show_button_state(ui_mgr.ChoiceState.CHOICE1)
func _on_move_pressed(btn: Button):
	var user = btn.get_meta("user")
	var move = btn.get_meta("move")
	var target = get_default_target(user)
	queue_move(user, target, move)
func get_default_target(user):
	if user in [player_monster1, player_monster2]:
		return enemy_monster1
	else:
		return player_monster1
func queue_move(user, target, move):
	var action = TurnAction.new(user, target, move)
	turn_actions.append(action)
	if all_moves_chosen():
		execute_turn()
func all_moves_chosen():
	if is_single:
		return turn_actions.size() == 1
	else:
		return turn_actions.size() == 2
func execute_turn():
	ui_mgr.buttons_off(true)
	enemy_choose_moves()
	sort_actions()
	for action in turn_actions:
		await resolve_action(action)
	turn_actions.clear()
	ui_mgr.buttons_off(false)
	ui_mgr.show_button_state(ui_mgr.ChoiceState.CHOICE1)
	sort_turn_queue()
	
func enemy_choose_moves():
	if is_single:
		var enemy = enemy_monster1
		var move = enemy_monster1.known_moves.pick_random()
		var target = get_default_target(enemy)
		queue_move(enemy, target, move)
	else:
		for i in range(2):
			var enemy = enemy_party.get_child(i)
			var move = enemy.known_moves.pick_random()
			var target = get_default_target(enemy)
			queue_move(enemy, target, move)
			
func sort_actions():
	turn_actions.sort_custom(Callable(self, "compare_turn_actions"))
func compare_turn_actions(a, b): # Helper
	var index_a = turn_queue.find(a.user)
	var index_b = turn_queue.find(b.user)
	return index_a - index_b

func resolve_action(action):
	var user = action.user
	var target = action.target
	var move = action.move
	if target:
		var dmg = battle_calc.calc_damage(user, target, move)
		target.health_component.take_damage(dmg)
		
		await txt_mgr.show_text("%s hit %s \nwith %s for %d damage" % [
				user.monster_name, target.monster_name, move.name, dmg])
		
		if target.health_component.is_dead():
			remove_from_battle(target)

func remove_from_battle(target):
	if target.health_component.is_dead():
		print("%s has fainted" % target.monster_data.species_name)
		if target in [enemy_monster1, enemy_monster2]:
			var xp = target.get_xp_yield()
			award_xp(xp)
			target.queue_free()
			if enemy_party.get_child_count() <= 1:
				end_battle()
				for slot in party.party_slots:
					slot.node.participated = false
		if target in [player_monster1, player_monster2]:
			var available = []
			for slot in party.party_slots:
				var mon = slot.node
				if mon != null and !mon.health_component.is_dead():
					available.append(mon)
			if available.size() > 0:
				print("choose a monster")
				end_battle()
			else:
				print("you lost")
				end_battle()

func award_xp(xp: int):
	for slot in party.party_slots:
		if slot.node.participated:
			slot.pm.experience += xp
			

func hide_health_bars():
	for node in turn_queue:
		if node.has_meta("HPBar"):
			var bar = node.get_meta("HPBar")
			bar.queue_free()
	for node in turn_queue:
		if node.has_meta("HPBar"):
			node.remove_meta("HPBar")
func clear_enemy_party():
	for child in enemy_party.get_children():
		child.queue_free()

func end_battle():
	clear_enemy_party()
	party.update_party_slots()
	ending_battle.emit()
	self.visible = false
	hide_health_bars()
	flip_physics_process(true)
	player.set_process_input(true)
	flip_camera()
	flip_ui_visibility(false)
	turn_queue.clear()

func _on_on_pressed() -> void:
	flip_ui_visibility(true)
func _on_off_pressed() -> void:
	flip_ui_visibility(false)
