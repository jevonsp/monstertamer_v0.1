extends Area2D

func _ready() -> void:
	add_to_group("healing")

func _on_player_can_heal() -> void:
	print("can_heal")
