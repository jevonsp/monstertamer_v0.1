extends Node2D

@export var party : Node
@export var menu_list : Node2D

enum Slot {SLOT1, SLOT2, SLOT3, SLOT4, SLOT5, SLOT6}
var selected_slot: int = Slot.SLOT1
var is_moving: bool = false
var index_move_slot : int = -1

@onready var slot : Dictionary = {
	Slot.SLOT1: $Slot1/Background,
	Slot.SLOT2: $Slot2/Background,
	Slot.SLOT3: $Slot3/Background,
	Slot.SLOT4: $Slot4/Background,
	Slot.SLOT5: $Slot5/Background,
	Slot.SLOT6: $Slot6/Background
}
	
func _ready() -> void:
	set_active_slot()
	set_process_input(false)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		unset_active_slot()
		selected_slot = (selected_slot + 1) % 6
		if is_moving:
			set_moving_slot()
		else:
			set_active_slot()
	elif event.is_action_pressed("up"):
		unset_active_slot()
		if selected_slot == 0:
			selected_slot = Slot.SLOT6
		else:
			selected_slot -= 1
		if is_moving:
			set_moving_slot()
		else:
			set_active_slot()
	elif event.is_action_pressed("yes"):
		if !is_moving:
			set_moving_slot()
			index_move_slot = selected_slot
			is_moving = true
		elif is_moving:
			swap_slots(index_move_slot, selected_slot)
			set_active_slot()
			is_moving = false
	if event.is_action_pressed("no"):
		if is_moving:
			unset_active_slot()
			selected_slot = index_move_slot # Restores to where we started
			set_active_slot()
			is_moving = false
			index_move_slot = -1
			print("cancelled moved")
		else:
			self.visible = false
			set_process_input(false)
			menu_list.set_process_input(true)
			
		
func unset_active_slot():
	slot[selected_slot].frame = 0
	
func set_active_slot():
	slot[selected_slot].frame = 1

func set_moving_slot():
	slot[selected_slot].frame = 2

func swap_slots(moving, selected):
	if moving == selected:
		return
	slot[moving].frame = 0
	slot[selected].frame = 1
	print(moving, selected)
	if party:
		var temp = party.party_slot[moving]
		party.party_slot[moving] = party.party_slot[selected]
		party.party_slot[selected] = temp
		print(party.party_slot[moving], party.party_slot[selected])
	else:
		print("no party yet")
