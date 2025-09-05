extends Node2D

signal party_options_closed
signal switch_requested

enum Slot {SWITCH, SUMMARY, CANCEL}
var selected_slot = Slot.SWITCH
@onready var slot : Dictionary = {
	Slot.SWITCH : $Switch/Background,
	Slot.SUMMARY : $Summary/Background,
	Slot.CANCEL : $Cancel/Background
}

func _ready() -> void:
	visible = false
	set_process_input(false)
	set_active_slot()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("yes"):
		set_process_input(false)
		switch_requested.emit()
	if event.is_action_pressed("no"):
		_set_ui_state(self, false)
		party_options_closed.emit()
	if event.is_action_pressed("down"):
		unset_active_slot()
		selected_slot = (selected_slot + 1) % 3
		set_active_slot()
	elif event.is_action_pressed("up"):
		unset_active_slot()
		if selected_slot == 0:
			selected_slot = Slot.CANCEL
		else:
			selected_slot -= 1
		set_active_slot()

func _move(direction):
	unset_active_slot()
	selected_slot = (selected_slot + 1) % 3
	set_active_slot()

func unset_active_slot():
	slot[selected_slot].frame = 0
	
func set_active_slot():
	slot[selected_slot].frame = 1

func _party_options_opened() -> void:
	_set_ui_state(self, true)

func _on_swap_complete() -> void:
	set_process_input(true)
	
func _on_switch_cancelled() -> void:
	set_process_input(true)

func _set_ui_state(node: Node2D, active: bool) -> void:
	node.visible = active
	node.set_process_input(active)
