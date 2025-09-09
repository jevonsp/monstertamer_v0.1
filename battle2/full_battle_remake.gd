extends Node2D

signal battle_ready
signal battle_finished
signal party_requested
signal battle_ui_requested
signal turn_action_swap(monster)
signal in_battle_true

@export var player : CharacterBody2D
@export var moves1 : Node2D
@export var options : Node2D
@export var pslot1 : Node2D
@export var eslot1 : Node2D

@export var in_battle : bool = false

func _ready() -> void:
	_hide_subscenes()
	
func _process(delta: float) -> void:
	var viewport_size = Vector2(640, 360)
	if player:
		if moves1.visible: moves1.global_position = player.global_position - (viewport_size / 2)
		if options.visible: options.global_position = player.global_position - (viewport_size / 2)
		if pslot1.visible: pslot1.global_position = player.global_position - (viewport_size / 2)
		if eslot1.visible: eslot1.global_position = player.global_position - (viewport_size / 2)

func _show_subscenes():
	var nodes = get_tree().get_nodes_in_group("battle_ui")
	for node in nodes:
		node.visible = true
func _hide_subscenes():
	var nodes = get_tree().get_nodes_in_group("battle_ui")
	for node in nodes:
		node.visible = false

func _on_party_requested() -> void:
	party_requested.emit()

func _on_party_closed() -> void:
	if in_battle:
		battle_ui_requested.emit()
		
func _on_first_party_member_changed(monster: MonsterInstance) -> void:
	$MonsterUpdater.update_player_monster(monster)

func _on_battle_monster_recieved(monster: MonsterInstance) -> void:
	print("updating em1")
	$MonsterUpdater.update_enemy_monster(monster)
	in_battle = true
	print("in_battle: ", in_battle)
	battle_ready.emit()
	in_battle_true.emit()
	_show_subscenes()
	print("encounter ready")

func _on_in_battle_switch_request(monster: MonsterInstance) -> void:
	turn_action_swap.emit(monster)
