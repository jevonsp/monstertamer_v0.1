extends Node2D

signal party_options_closed
signal switch_requested(selected_slot: int)

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
	print("PartyOptions ready! Visible:", visible, "Parent:", get_parent().name)

func _input(event: InputEvent) -> void:
	# Movement around the menu
	if event.is_action_pressed("down"):
		unset_active_slot()
		selected_slot = ((selected_slot + 1) % 3) as Slot
		set_active_slot()
	elif event.is_action_pressed("up"):
		unset_active_slot()
		if selected_slot == 0:
			selected_slot = Slot.CANCEL
		else:
			selected_slot = (selected_slot - 1) as Slot
		set_active_slot()
	# Switching Monsters
	if selected_slot == Slot.SWITCH:
		if event.is_action_pressed("yes"):
			set_process_input(false)
			switch_requested.emit()
		elif event.is_action_pressed("no"):
			_set_ui_state(self, false)
			party_options_closed.emit()
	elif selected_slot == Slot.SUMMARY and event.is_action_pressed("yes"): print("no summary yet")
	elif selected_slot == Slot.CANCEL and event.is_action_pressed("yes"):
		_set_ui_state(self, false)
		party_options_closed.emit()

func unset_active_slot():
	slot[selected_slot].frame = 0
	
func set_active_slot():
	slot[selected_slot].frame = 1

func _party_options_opened() -> void:
	_set_ui_state(self, true)

func _on_swap_complete() -> void:
	_set_ui_state(self, false)
	
func _on_switch_cancelled() -> void:
	set_process_input(true)

func _set_ui_state(node: Node2D, active: bool) -> void:
	node.visible = active
	node.set_process_input(active)
