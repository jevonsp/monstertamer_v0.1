extends Node2D
signal party_requested
signal party_closed

@export var in_battle : bool = false

func _ready() -> void:
	pass

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
	party_closed.emit()
