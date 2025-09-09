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
	selected_slot.y = clamp(selected_slot.y, 0, 1)
	set_active_slot()

func _input_action():
	var current_enum = v2_to_slot[selected_slot]
	option_pressed.emit(current_enum)
	print("current enum %d emitted" % current_enum)

func _on_battle_started() -> void:
	_set_ui_state(self, true)

func get_curr_slot():
	return v2_to_slot[selected_slot]

func unset_active_slot():
	slot[get_curr_slot()].frame = 0
	
func set_active_slot():
	slot[get_curr_slot()].frame = 1
	
func _set_ui_state(node: Node2D, active: bool) -> void:
	node.visible = active
	node.set_process_input(active)
