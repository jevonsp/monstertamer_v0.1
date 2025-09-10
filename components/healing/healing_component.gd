extends Area2D

signal full_heal

func _ready() -> void:
	add_to_group("healing")
	
func send_healing() -> void:
	full_heal.emit()
	print("asked for healing")
