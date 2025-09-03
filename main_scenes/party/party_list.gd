extends Node2D

signal closed

@export_subgroup("Nodes")
@export var party : Node
@export var menu_list : Node2D
@export var player : CharacterBody2D

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
@onready var slot_images : Dictionary = {
	Slot.SLOT1: $Slot1/TextureRect,
	Slot.SLOT2: $Slot2/TextureRect,
	Slot.SLOT3: $Slot3/TextureRect,
	Slot.SLOT4: $Slot4/TextureRect,
	Slot.SLOT5: $Slot5/TextureRect,
	Slot.SLOT6: $Slot6/TextureRect
}
@onready var slot_names : Dictionary = {
	Slot.SLOT1: $Slot1/NameLabel,
	Slot.SLOT2: $Slot2/NameLabel,
	Slot.SLOT3: $Slot3/NameLabel,
	Slot.SLOT4: $Slot4/NameLabel,
	Slot.SLOT5: $Slot5/NameLabel,
	Slot.SLOT6: $Slot6/NameLabel
}
@onready var slot_lvls : Dictionary = {
	Slot.SLOT1: $Slot1/LvlLabel,
	Slot.SLOT2: $Slot2/LvlLabel,
	Slot.SLOT3: $Slot3/LvlLabel,
	Slot.SLOT4: $Slot4/LvlLabel,
	Slot.SLOT5: $Slot5/LvlLabel,
	Slot.SLOT6: $Slot6/LvlLabel
}
@onready var slot_bars : Dictionary = {
	Slot.SLOT1: $Slot1/ProgressBar,
	Slot.SLOT2: $Slot2/ProgressBar,
	Slot.SLOT3: $Slot3/ProgressBar,
	Slot.SLOT4: $Slot4/ProgressBar,
	Slot.SLOT5: $Slot5/ProgressBar,
	Slot.SLOT6: $Slot6/ProgressBar
}
func _ready() -> void:
	set_active_slot()
	set_process_input(false)
	update_slots()
	
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
			closed.emit()
			
func unset_active_slot():
	slot[selected_slot].frame = 0
	
func set_active_slot():
	slot[selected_slot].frame = 1

func set_moving_slot():
	slot[selected_slot].frame = 2
# connected through editor from Party
func update_slots():
	for i in range(6):
		var has_monster = (party.party_slots.size() > i and party.party_slots[i] != null and 
		party.party_slots[i].pm and party.party_slots[i].pm.base_data)
		if has_monster:
			var slot_data = party.party_slots[i]
			slot_images[i].texture = slot_data.pm.base_data.texture
			var display_name = (slot_data.pm.nick_name if slot_data.pm.nick_name != "" 
			else slot_data.pm.monster_name)
			slot_names[i].text = display_name
			slot_lvls[i].text = ("Lvl : %s" %  slot_data.pm.level)
			slot_bars[i].max_value = slot_data.pm.max_hp
			slot_bars[i].value = slot_data.pm.current_hp
			print("Slot ", i, " level: ", slot_data.pm.level)
			print("Setting text to: Lvl : ", slot_data.pm.level)
			slot_lvls[i].text = ("Lvl : %s" % slot_data.pm.level)
			print("Label text is now: ", slot_lvls[i].text)
		else:
			slot_images[i].texture = null
			slot_names[i].text = ""
			slot_lvls[i].text = ""
			print("no pm")
		slot_images[i].visible = has_monster
		slot_names[i].visible = has_monster
		slot_lvls[i].visible = has_monster
		slot_bars[i].visible = has_monster
			
func swap_slots(moving, selected):
	if moving == selected:
		return
	slot[moving].frame = 0
	slot[selected].frame = 1
	print(moving, selected)
	if party:
		var temp = party.party_slots[moving]
		print(party.party_slots[moving], party.party_slots[selected])
		party.party_slots[moving] = party.party_slots[selected]
		party.party_slots[selected] = temp
		print(party.party_slots[moving], party.party_slots[selected])
	else:
		print("no party yet")
	update_slots()


func _on_party_party_healed() -> void:
	update_slots()
