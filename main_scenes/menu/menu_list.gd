extends Node2D

signal party_selected
signal invent_selected
signal save_selected
signal closed

enum Slot {PARTY, INVENT, SAVE}
var selected_slot = Slot.PARTY

@export var party_list : Node2D

@onready var slot : Dictionary = {
	Slot.PARTY: $Party/Background,
	Slot.INVENT: $Invent/Background,
	Slot.SAVE: $Save/Background
}

func _ready() -> void:
	set_active_slot()
	self.visible = false

func unset_active_slot():
	slot[selected_slot].frame = 0
	
func set_active_slot():
	slot[selected_slot].frame = 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		unset_active_slot()
		selected_slot = (selected_slot + 1) % 3
		set_active_slot()
	elif event.is_action_pressed("up"):
		unset_active_slot()
		if selected_slot == 0:
			selected_slot = Slot.SAVE
			set_active_slot()
		else:
			selected_slot -= 1
			set_active_slot()
	elif event.is_action_pressed("yes"):
		match selected_slot:
			Slot.PARTY:
				print("open party")
				party_selected.emit()
			Slot.INVENT:
				print("no invent yet")
				invent_selected.emit()
			Slot.SAVE:
				print("save game")
				save_selected.emit()
	elif event.is_action_pressed("no"):
		print("closed menu")
		closed.emit()
