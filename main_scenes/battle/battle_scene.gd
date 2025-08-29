extends Node2D

signal battle_ended

# later use signal from encounter zone to flip these, clean them up at the end
@export var is_double : bool = false
@export var camera : Camera2D
@export_subgroup("Nodes")
@export var enemy_party : Node
@export var battle_manager : Node

var allowed_to_target : bool = false
# Encounter zone will emit signal to party which then in turn makes an array and emits it to battle scene
var party : Array[MonsterInstance] = []

var is_wild : bool = false

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("target"):
		node.disabled
	
func setup_battle():
	%Options/Fight.grab_focus()
	show_ui()
	setup_player_monsters()
	#setup_enemy_monsters()
	
func end_battle():
	is_double  = false
	hide_ui()

func _on_party_monster_for_queue(node: MonsterInstance) -> void:
	battle_manager.add_to_turn_queue(node)

func _on_enemy_party_enemy_monster_for_queue(node: MonsterInstance) -> void:
	battle_manager.add_to_turn_queue(node)

func setup_player_monsters():
	for monster_instance in party:
		# display image
		pass
	
func setup_enemy_monsters(enemy_data: MonsterData, level: int):
	pass

func get_target():
	allowed_to_target = true
	%Targets.visible = true
	print("attempting to grab focus")
	%Targets/Target3.grab_focus()

func show_ui():
	camera.make_current()
	self.visible = true
	%Moves1.visible = false
	%Moves2.visible = false
	# if its a singble battle
	if !is_double:
		%TopNames.visible = false
		%TopBars.visible = false
		%DoubleBattle.visible = false
		%SingleBattle.visible = true
	# if its a double battle
	if is_double:
		%TopNames.visible = true
		%TopBars.visible = true
		%DoubleBattle.visible = true
		%SingleBattle.visible = false
	
func hide_ui():
	self.visible = false
	camera.enabled = false
	
