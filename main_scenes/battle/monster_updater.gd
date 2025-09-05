extends Node



func _hide_children() -> void:
	for node in get_children():
		node.visible = false
		
func _show_children() -> void:
	for node in get_children():
		node.visible = true
