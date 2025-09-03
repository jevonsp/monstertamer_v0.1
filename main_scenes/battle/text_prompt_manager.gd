extends Control
signal text_read

var string : String
#Emits done with text when yes pressed
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("yes"):
		text_read.emit()
# From Battle Scene, makes string
func _on_battle_scene_3_attack_happened(user: Variant, target: Variant, move: Variant, damage: Variant) -> void:
	string = "user hit target with move for x damage"
# After Move hits we can display
func _on_battle_scene_3_text_ready() -> void:
	print(string)
	string = ""
