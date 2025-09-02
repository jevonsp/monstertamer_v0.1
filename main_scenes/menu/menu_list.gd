extends Node2D

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
	set_process_input(false)

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
	if event.is_action_pressed("yes"):
		if selected_slot == Slot.PARTY:
			print("open party")
		elif selected_slot == Slot.INVENT:
			print("no invent yet")
		elif selected_slot == Slot.SAVE:
			print("save game")
	if event.is_action_pressed("no"):
		self.visible = false
