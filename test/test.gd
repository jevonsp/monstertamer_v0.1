extends Node2D

signal starting_level(level: int)
signal tween_finished

@export var monster_data : MonsterData
@export var monster_factory : Node

var monster : Node
var current_level : int = 1
var label_level : int
var current_experience : int = 0

func _ready():
	starting_level.connect(_store_starting_label)
	tween_finished.connect(_update_label)
	monster = monster_factory.create_monster(monster_data, 10)
	add_child(monster)

func _on_inc_exp_pressed() -> void:
	current_experience += 100
	print("Level: %d, Current XP: %d" % [current_level, current_experience])

	var times_to_tween = 0
	var new_level = current_level
	
	# figure out how many levels you gained
	while current_experience >= exp_formula(new_level + 1):
		times_to_tween += 1
		new_level += 1

	starting_level.emit(current_level)
	current_level = new_level

	# leftover = xp into current level
	var leftover = current_experience - exp_curr()
	var denom = exp_next() - exp_curr()
	var last_bar_percent = (leftover / denom) * 100.0

	print("Times to tween: %d" % times_to_tween)
	print("Current level: %d" % current_level)
	print("Leftover exp: %d" % leftover)
	print("Percent into bar: %f" % last_bar_percent)

	# animate bars
	while times_to_tween > 0:
		times_to_tween -= 1
		var tween = get_tree().create_tween()
		tween.tween_property(%ExpBar, "value", 100, 0.5)
		await tween.finished
		tween_finished.emit()
		%ExpBar.value = 0
		await get_tree().create_timer(0.2).timeout

	var tween = get_tree().create_tween()
	tween.tween_property(%ExpBar, "value", last_bar_percent, 0.5)

func _store_starting_label(level: int) -> void:
	label_level = level
	print("label_level is: %d" % label_level)

func _update_label():
	label_level += 1
	print("label_level increased to: %d" % label_level)
	%ExpBar/LevelIndicator.text = "Lvl. " + str(label_level)

func exp_formula(plevel):
	const BASE = 100
	return BASE * pow(plevel - 1, 2) # -1 so it returns 0 at 1. 100 at 2.

func exp_curr():
	return exp_formula(current_level)

func exp_next():
	return exp_formula(current_level + 1)
	
func exp_percent() -> float:
	var numerator = current_experience - exp_curr() 
	var denominator = exp_next() - exp_curr()
	return (numerator/denominator) * 100   

#region Working Bar Tween
func _on_inc_lvl_pressed() -> void:
	test_tween_bar(100)
	test_level_up()

func test_tween_bar(new):
	print("tweening to: %f" % new)
	var tween = get_tree().create_tween()
	tween.tween_property(%ExpBar, "value", new, 0.5)
	if new == 100: 
		tween.tween_callback(test_reset_tween)
		
func test_level_up():
	%ExpBar/LevelIndicator.text = "Lvl. " + str(current_level)
	print("level visually incremented to: %d" % current_level)

func test_reset_tween():
	%ExpBar.value = 0
	current_level += 1
	test_level_up()
#endregion
