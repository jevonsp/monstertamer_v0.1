extends Node2D
signal party_requested
signal battle_started
signal battle_ui_requested

@export var in_battle : bool = false

func _ready() -> void:
	pass
	#_hide_subscenes()
	#if in_battle: _show_subscenes()

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
	battle_ui_requested.emit()

func _on_first_party_member_changed(monster: MonsterInstance) -> void:
	$MonsterUpdater.update_player_monster(monster)

func _on_battle_monster_recieved(monster: MonsterInstance) -> void:
	print("updating em1")
	$MonsterUpdater.update_enemy_monster(monster)
