extends Node2D

signal pm1_move_used(slot : int)

@export var is_enabled : bool = false

enum Slot {BUTTON1, BUTTON2, BUTTON3, BUTTON4}

var selected_slot : Vector2 = Vector2(1,0)
var is_moving : bool = false
var index_move_slot : int = -1

var v2_to_slot : Dictionary = {
	Vector2(0,0): Slot.BUTTON1,
	Vector2(1,0): Slot.BUTTON2,
	Vector2(0,1): Slot.BUTTON3,
	Vector2(1,1): Slot.BUTTON4 }
var slot_to_v2 : Dictionary = {
	Slot.BUTTON1 : Vector2(0,0),
	Slot.BUTTON2 : Vector2(1,0),
	Slot.BUTTON3 : Vector2(0,1),
	Slot.BUTTON4 : Vector2(1,1) }

@onready var slot : Dictionary = {
	Slot.BUTTON1: $Button1/Background,
	Slot.BUTTON2: $Button2/Background,
	Slot.BUTTON3: $Button3/Background,
	Slot.BUTTON4: $Button4/Background }
@onready var move_name : Dictionary = {}
@onready var move_color : Dictionary = {}
@onready var move_power : Dictionary = {}

func _ready() -> void:
	set_active_slot()
	set_process_input(false)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("yes"):
		if !is_moving:
			input_move()
		#else:
			#swap_slots(index_move_slot, selected_slot)
	if event.is_action_pressed("up"):
		_move(Vector2.UP)
	if event.is_action_pressed("down"):
		_move(Vector2.DOWN)
	if event.is_action_pressed("left"):
		_move(Vector2.LEFT)
	if event.is_action_pressed("right"):
		_move(Vector2.RIGHT)
	if event.is_action_pressed("menu"):
		pass
		#start_move_swap()
		
func _move(direction: Vector2):
	unset_active_slot()
	selected_slot += direction
	selected_slot.x = clamp(selected_slot.x, 0, 1)
	selected_slot.y = clamp(selected_slot.y, 0, 1)
	if is_moving:
		set_moving_slot()
	else:
		set_active_slot()

func _on_fight_pressed() -> void:
	pass

func input_move():
	var current_enum = v2_to_slot[selected_slot]
	pm1_move_used.emit(current_enum)
	set_process_input(false)
	print("move_used emitted: %d" % current_enum)
	
func reset_moves_menu():
	set_process_input(true)
	set_active_slot()

func get_curr_slot():
	return v2_to_slot[selected_slot]

func unset_active_slot():
	slot[get_curr_slot()].frame = 0
	
func set_active_slot():
	slot[get_curr_slot()].frame = 1

func set_moving_slot():
	slot[get_curr_slot()].frame = 2
	
#func start_move_swap() -> void:
	#is_moving = true
	#set_moving_slot()
	#var current_enum = v2_to_slot[selected_slot]
	#index_move_slot = current_enum
		#
#func swap_slots(moving, selected):
	#var current_enum = v2_to_slot[selected_slot]
	#if moving == current_enum:
			#return
	#slot[moving].frame = 0
	#slot[current_enum].frame = 1
	#print(moving, selected)
	#index_move_slot = -1
	#is_moving = false
