extends Control

signal confirmed

@export var arrow : Node2D

var awaiting_confirm : bool = false

func _ready() -> void:
	process_priority = 10 
	set_process_input(false)

func _input(event: InputEvent) -> void:
	if !awaiting_confirm: return
	if event.is_action_pressed("yes"):
		print("Text manager: YES pressed, emitting confirmed")
		awaiting_confirm = false
		arrow.still()
		confirmed.emit()
		print("Text manager: _input() calling set_process_input(false)")
		set_process_input(false)
		print("Text manager: Set process_input to false")

func _on_battle_manager_text_ready(user: MonsterInstance, target: MonsterInstance, move: Move, damage: int, effective: float, weak_point: float) -> void:
	print("Text manager: Received text_ready signal")
	# Clear any buffered input events
	Input.flush_buffered_events()
	var string = make_text(user, target, move, damage, effective, weak_point)
	display_text(string)
	arrow.blinking()
	# Small delay to avoid processing leftover events
	await get_tree().create_timer(0.05).timeout
	awaiting_confirm = true
	set_process_input(true)

func make_text(user, target, move, damage, effective, weak_point) -> String:
	var text = "%s used %s on %s!\n" % [user.species, move.move_name, target.monster_name]
	if effective < 1.0:
		text += "Not very effective...It dealt %d damage.\n" % damage
	if effective > 1.0:
		text += "Super effective! It dealt %d damage!\n" % damage
	if weak_point > 1.0:
		text += "You found a weak point!"
	return text
	
func display_text(string: String):
	%Label.clear()
	%Label.append_text(string)
	
