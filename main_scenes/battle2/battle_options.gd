extends Node2D

signal option_pressed

enum Slot {MONSTERS, FIGHT, RUN, ITEMS}
var selected_slot : Vector2 = Vector2(1,0)
var v2_to_slot : Dictionary = {
	Vector2(0,0): Slot.MONSTERS,
	Vector2(1,0): Slot.FIGHT,
	Vector2(0,1): Slot.RUN,
	Vector2(1,1): Slot.ITEMS }
var slot_to_v2 : Dictionary = {
	Slot.MONSTERS : Vector2(0,0),
	Slot.FIGHT : Vector2(1,0),
	Slot.RUN : Vector2(0,1),
	Slot.ITEMS : Vector2(1,1) }

@onready var slot : Dictionary = {
	Slot.MONSTERS: $Monsters/Background,
	Slot.FIGHT: $Fight/Background,
	Slot.RUN: $Run/Background,
	Slot.ITEMS: $Items/Background }

func _ready() -> void:
	set_active_slot()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("yes"):
		_input_action()
	if event.is_action_pressed("up"):
		_move(Vector2.UP)
	if event.is_action_pressed("down"):
		_move(Vector2.DOWN)
	if event.is_action_pressed("left"):
		_move(Vector2.LEFT)
	if event.is_action_pressed("right"):
		_move(Vector2.RIGHT)

func _move(direction: Vector2):
	unset_active_slot()
	selected_slot += direction
	selected_slot.x = clamp(selected_slot.x, 0, 1)
	selected_slot.y = clamp(selected_slot.y, 0, 1)
	set_active_slot()

func _input_action():
	var current_enum = v2_to_slot[selected_slot]
	option_pressed.emit(current_enum)
		
func unset_active_slot():
	var current_enum = v2_to_slot[selected_slot]
	slot[current_enum].frame = 0
	
func set_active_slot():
	var current_enum = v2_to_slot[selected_slot]
	slot[current_enum].frame = 1
