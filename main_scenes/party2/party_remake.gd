extends Node2D

signal party_options_opened
signal swap_completed

enum Slot {SLOT1, SLOT2, SLOT3, SLOT4, SLOT5, SLOT6}
var selected_slot : Vector2 = Vector2(0,0)
var is_moving : bool = false
var index_move_slot : int = -1
var in_battle : bool = false

@onready var slot : Dictionary = {
	Slot.SLOT1: $Slot1/Background,
	Slot.SLOT2: $Slot2/Background,
	Slot.SLOT3: $Slot3/Background,
	Slot.SLOT4: $Slot4/Background,
	Slot.SLOT5: $Slot5/Background,
	Slot.SLOT6: $Slot6/Background}
@onready var v2_to_slot : Dictionary = {
	Vector2(0,0) : Slot.SLOT1,
	Vector2(1,0) : Slot.SLOT2,
	Vector2(1,1) : Slot.SLOT3,
	Vector2(1,2) : Slot.SLOT4,
	Vector2(1,3) : Slot.SLOT5,
	Vector2(1,4) : Slot.SLOT6}
@onready var slot_to_v2 : Dictionary = {
	Slot.SLOT1 : Vector2(0,0),
	Slot.SLOT2 : Vector2(1,0),
	Slot.SLOT3 : Vector2(1,1),
	Slot.SLOT4 : Vector2(1,2),
	Slot.SLOT5 : Vector2(1,3),
	Slot.SLOT6 : Vector2(1,4)}
func _ready() -> void:
	set_active_slot()
	#set_process_input(false)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("yes"):
		if !is_moving:
			set_process_input(false)
			party_options_opened.emit()
		else:
			swap_slots(index_move_slot, selected_slot)
	if event.is_action_pressed("up"):
		_move(Vector2.UP)
	elif event.is_action_pressed("down"):
		_move(Vector2.DOWN)
	elif event.is_action_pressed("left"):
		_move(Vector2.LEFT)
	elif event.is_action_pressed("right"):
		_move(Vector2.RIGHT)
	
func _move(direction: Vector2):
	unset_active_slot()
	selected_slot += direction
	selected_slot.x = clamp(selected_slot.x, 0, 1)
	selected_slot.y = clamp(selected_slot.y, -1, 5)
	if selected_slot.x == 0: selected_slot = Vector2(0,0)
	if selected_slot.y == -1: selected_slot = Vector2(1,4)
	if selected_slot.y == 5: selected_slot = Vector2(1,0)
	if is_moving:
		set_moving_slot()
	else:
		set_active_slot()

func unset_active_slot():
	var current_enum = v2_to_slot[selected_slot]
	slot[current_enum].frame = 0
	
func set_active_slot():
	var current_enum = v2_to_slot[selected_slot]
	slot[current_enum].frame = 1

func set_moving_slot():
	var current_enum = v2_to_slot[selected_slot]
	slot[current_enum].frame = 2

func _on_in_battle() -> void:
	in_battle = true

func _on_switch_requested() -> void:
	set_process_input(true)
	is_moving = true
	set_moving_slot()
	var current_enum = v2_to_slot[selected_slot]
	index_move_slot = current_enum

func swap_slots(moving, selected):
	var current_enum = v2_to_slot[selected_slot]
	if moving == current_enum:
		return
	slot[moving].frame = 0
	slot[current_enum].frame = 1
	print(moving, current_enum)
	index_move_slot = -1
	is_moving = false
	set_process_input(false)
	swap_completed.emit()
	
func on_party_options_closed() -> void:
	_set_ui_state(self, true)

func _set_ui_state(node: Node2D, active: bool) -> void:
	node.visible = active
	node.set_process_input(active)
