extends Node2D

signal party_options_opened(current_enum)
signal reorder_requested(from_slot: int, to_slot: int)
signal reorder_completed
signal monster_switch_requested(chosen_monster : MonsterInstance)
signal switch_cancelled

signal party_closed
signal first_party_memeber(monster : MonsterInstance)

@export var party_container : Node
@export var camera : Camera2D

@export var process_input : bool
@export var is_enabled : bool = false

enum Slot {SLOT1, SLOT2, SLOT3, SLOT4, SLOT5, SLOT6}

var selected_slot : Vector2 = Vector2(0,0)
var is_moving : bool = false
var index_move_slot : int = -1
var in_battle : bool = false

var party_array : Array[Node] = []

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
	visible = false
	set_process_input(false)
	set_active_slot()
	
func _input(event: InputEvent) -> void:
	if !is_enabled:
		return
	if event.is_action_pressed("no"):
		if is_moving:
			is_moving = false
			set_active_slot()
			switch_cancelled.emit()
			set_process_input(false)
		else:
			is_enabled = false
			_set_ui_state(self, false)
			party_closed.emit()
	if event.is_action_pressed("yes"):
		if !is_moving:
			set_process_input(false)
			party_options_opened.emit(v2_to_slot[selected_slot])
			print(selected_slot)
		else:
			reorder_slots(index_move_slot, selected_slot)
	if event.is_action_pressed("menu"):
		is_enabled = false
		_set_ui_state(self, false)
		party_closed.emit()
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
	var next_slot = selected_slot + direction
	next_slot.x = clamp(next_slot.x, 0, 1)
	
	var max_y = 0
	if next_slot.x == 0: max_y = 0
	else: max_y = max(0, min(4, party_array.size() - 2))
	
	if next_slot.y < 0: next_slot.y = max_y 
	elif next_slot.y > max_y: next_slot.y = 0
	
	if _v2_to_index(next_slot) >= party_array.size(): next_slot = selected_slot 
	selected_slot = next_slot

	if is_moving:
		set_moving_slot()
	else:
		set_active_slot()

func _v2_to_index(v: Vector2) -> int:
	if v.x == 0:
		return 0
	else:
		return int(v.y) + 1

func _on_party_monster_sent(monster) -> void:
	if party_array.size() < 6:
		party_container.add_child(monster)
		party_array.append(monster)
		print(party_container.get_children().size())
		update_display()
		print("asked for updated display")
	first_party_memeber.emit(party_array[0])
	print("emitted party_array[0]")

#region Slot Display Code

func update_display(): # call this when swapping too (later)
	for i in range(6):
		var monster = null
		if i < party_array.size():
			monster = party_array[i]
		var slot_node = get_node("Slot" + str(i+1)) as Node
		if slot_node:
			slot_node.assign_monster(monster)
	first_party_memeber.emit(party_array[0])
	print("party_array[0].known_moves: ", party_array[0].known_moves)
#endregion

#region Slot Movement Code
func get_curr_slot():
	return v2_to_slot[selected_slot]

func unset_active_slot():
	slot[get_curr_slot()].frame = 0
	
func set_active_slot():
	slot[get_curr_slot()].frame = 1

func set_moving_slot():
	slot[get_curr_slot()].frame = 2

func _on_party_opened(current_enum) -> void:
	if current_enum == 0:
		print("success")
		_set_ui_state(self, true)

func _on_in_battle() -> void:
	in_battle = true
	print("in_battle = true")

func _on_switch_requested(selected_monster_slot) -> void:
	if in_battle:
		if selected_monster_slot == 0: 
			switch_cancelled.emit()
			set_process_input(false)
			party_options_opened.emit(v2_to_slot[selected_slot])
			return
		switch_to_front(selected_monster_slot)
		var chosen_monster = party_array[0]
		monster_switch_requested.emit(chosen_monster)
		set_process_input(false)
		_set_ui_state(self, false)
		party_closed.emit()
		print("in_battle switch here")
	else:
		set_process_input(true)
		is_moving = true
		set_moving_slot()
		var current_enum = v2_to_slot[selected_slot]
		index_move_slot = current_enum

func switch_to_front(selected_slot: int) -> void:
	if selected_slot == 0: return
	var temp = party_array[0]
	party_array[0] = party_array[selected_slot]
	party_array[selected_slot] = temp
	update_display()

func reorder_slots(moving, selected_slot):
	var current_enum = v2_to_slot[selected_slot]
	if party_array.size() == 0: return
	if moving == current_enum: return
	
	slot[moving].frame = 0
	slot[current_enum].frame = 1

	reorder_requested.emit(moving, current_enum)

	index_move_slot = -1
	is_moving = false
	update_display()
	reorder_completed.emit()

func _on_swap_requested(moving, current_enum):
	if !in_battle:
		var temp = party_array[moving]
		party_array[moving] = party_array[current_enum]
		party_array[current_enum] = temp
	else: print("in_battle test")

func _on_party_requested() -> void:
	print("recieved party_req")

	_set_ui_state(self, true)
	update_display()

func _on_party_options_closed() -> void:
	_set_ui_state(self, true)

func _set_ui_state(node: Node2D, active: bool) -> void:
	is_enabled = active
	node.visible = active
	node.set_process_input(active)
#endregion

#region Testing Buttons

func _on_exp_pressed() -> void:
	for node in party_array:
		node.gain_exp(1000)
		print(node.experience)
	$Control/Exp.release_focus()

func _on_lvl_pressed() -> void:
	for node in party_array:
		node.level_up()
	$Control/Lvl.release_focus()

func _on_minus_hp_pressed() -> void:
	print("minus pressed")
	for node in party_array:
		node.lose_life(5)
	$Control/minusHP.release_focus()

func _on_plus_hp_pressed() -> void:
	print("plus pressed")
	for node in party_array:
		node.gain_life(5)
	$Control/plusHP.release_focus()

#endregion

func _on_full_battle_remake_party_requested() -> void:
	update_display()

func _on_test_spawner_monster_made(node: Variant) -> void:
	_on_party_monster_sent(node)
