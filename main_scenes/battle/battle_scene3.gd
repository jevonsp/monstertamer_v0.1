extends Node2D

signal monsters_setup
signal main_monster_changed

enum TurnState {PLAYER, ENEMY, ENDING}

@export_subgroup("Nodes")
@export var party : Node
@export var enemy_party : Node
@export var canvas_layer : CanvasLayer
@export var player : CharacterBody2D
@export var camera : Camera2D
@export var pm1 : VBoxContainer
@export var em1 : VBoxContainer
@export var move_buttons : GridContainer
@export var capture_manager : Node
@export var storage_manager : Node
@export var monster_factory : Node
@export_subgroup("Sub Nodes")
@export var sprite1 : Sprite2D
@export var label1 : Label
@export var sprite2 : Sprite2D
@export var label2 : Label

var player_bars : Array = []
var enemy_bars : Array = []

var player_monster : Node
var enemy_monster : Node

var turn_queue : Array[MonsterInstance] = []
var turn_state = TurnState.PLAYER

var in_battle : bool = false
var is_single : bool = true
var hp_bar_scene = preload("res://main_scenes/battle/progress_bar.tscn")

func _ready():
	for button in move_buttons.get_children():
		button.pressed.connect(_on_move_pressed.bind(button.get_index()))
func _process(delta: float) -> void:
	if in_battle and Input.is_action_just_pressed("ui_cancel"):
		end_battle()

func start_battle():
	print("got signal")
	spawn_player_monsters()
	player.set_physics_process(false)
	camera.make_current()
	in_battle = true
	self.visible = true
	canvas_layer.visible = true
	setup_monsters()
	setup_bars()
	setup_moves()
	for m in turn_queue:
		print(m.name, m.stats_component.current_speed)
	advance_turn()

func spawn_player_monsters():
	for i in range(storage_manager.player_party.size()):
		var pm = storage_manager.player_party[i]
		var node = monster_factory.create_from_pm(pm)
		party.add_child(node)

func setup_monsters():
	for node in party.get_children():
		if node is MonsterInstance and node.monster_data != null:
			player_monster = node
			label1.text = node.monster_data.species_name
			sprite1.texture = node.monster_data.texture
			turn_queue.append(node)
			print(turn_queue)
	for node in enemy_party.get_children():
		if node is MonsterInstance and node.monster_data != null:
			enemy_monster = node
			label2.text = node.monster_data.species_name
			sprite2.texture = node.monster_data.texture
			turn_queue.append(node)
			print(turn_queue)
	setup_bars()
	sort_turn_queue()

func setup_bars():
	for node in turn_queue:
		if node is MonsterInstance and node.health_component:
			if not node.has_meta("HPBar"):
				var bar = hp_bar_scene.instantiate()
				pm1.add_child(bar)
				bar.bind_to_monster(node)
				node.set_meta("HPBar", bar)
		else:
			print("Party node missing health_component or wrong type: ", node.name)

func setup_moves():
	var known_moves = party.get_child(0).known_moves
	var buttons = move_buttons.get_children()
	for i in range(min(buttons.size(), known_moves.size())):
		buttons[i].text = known_moves[i].name

func _monster_speed_less(a: MonsterInstance, b: MonsterInstance) -> bool:
	return a.stats_component.current_speed < b.stats_component.current_speed

func sort_turn_queue():
	turn_queue.sort_custom(_monster_speed_less)
	print(turn_queue)
	
func next_turn():
	var current = turn_queue[0]
	if current.get_parent() == party:
		turn_state = TurnState.PLAYER
	else:
		turn_state = TurnState.ENEMY
		enemy_take_turn(current)
		
func enemy_take_turn(monster: MonsterInstance):
	if monster.known_moves.size() == 0:
		advance_turn()
		return
	var move = monster.known_moves.pick_random()
	var target = pick_enemy_target(monster)
	calc_damage(monster, target, move)
	var timer = Timer.new()
	timer.wait_time = .5
	add_child(timer)
	timer.start()
	await timer.timeout
	advance_turn()
	
func pick_enemy_target(monster: MonsterInstance):
	return player_monster
func pick_player_target(monster: MonsterInstance):
	return enemy_monster
	
func advance_turn():
	if turn_queue.size() == 1:
		end_battle()
	for monster in turn_queue.duplicate():
		if monster.health_component.current_hp <= 0:
			handle_monster_death(monster)
			turn_queue.erase(monster)
	if turn_queue.is_empty():
		end_battle()
		return
	turn_queue.append(turn_queue.pop_front())
	next_turn()
	
func handle_monster_death(monster):
	if monster == enemy_monster:
		print("you win!")
		end_battle()
	else:
		print("you lose :(")
		end_battle()
		
func _on_move_pressed(move_index: int):
	if player_monster and player_monster.known_moves.size() > move_index:
		var move = player_monster.known_moves[move_index]
		calc_damage(player_monster, enemy_monster, move)
		var timer = Timer.new()
		timer.wait_time = .5
		add_child(timer)
		timer.start()
		await timer.timeout
		advance_turn()

func calc_damage(user, target, move):
	# can replace move.damage with some calculation using move.damage here later
	apply_move(user, target, move.damage)
func apply_move(user: MonsterInstance, target : MonsterInstance, damage: int):
	target.health_component.take_damage(damage)
	
func capture_pressed():
	capture_manager.attempt_capture(enemy_monster)
func capture_succeeded():
	if enemy_party.get_child_count() == 0:
		end_battle()

func end_battle():
	clean_up_bars()
	for enemy in enemy_party.get_children():
		enemy.queue_free()
	turn_queue.clear()
	player.set_physics_process(true)
	in_battle = false
	self.visible = false
	canvas_layer.visible = false
	if player:
		player.camera.make_current()
func clean_up_bars():
	for bar in pm1.get_children():
		if bar is ProgressBar:
			bar.queue_free()
	for bar in em1.get_children():
		if bar is ProgressBar:
			bar.queue_free()
