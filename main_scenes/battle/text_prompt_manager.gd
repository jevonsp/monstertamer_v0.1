extends Control
signal text_read

@export var label : Label

var string : String
var can_read_text : bool = false
#Emits done with text when yes pressed, fires too many times right now
func _ready() -> void:
	label.text = ""

func _process(delta: float) -> void:
	if can_read_text and Input.is_action_just_pressed("yes"):
		text_read.emit()

func show_text(new_string: String) -> void:
	label.text = new_string
	can_read_text = true
	await wait_for_confirm()
	label.text = ""
	can_read_text = false

func wait_for_confirm() -> void:
	await self.text_read
