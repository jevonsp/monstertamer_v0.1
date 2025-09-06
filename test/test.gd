extends Node2D

@export var monster_data : MonsterData
@export var monster_factory : Node

var monster : Node
var current_level : int = 1
var current_experience : int = 0

func _ready():
	monster = monster_factory.create_monster(monster_data, 10)
	add_child(monster)

func _on_inc_exp_pressed() -> void:
	gain_exp(100)
	
func gain_exp(amount):
	current_experience += amount
	tween_bar(get_percentage_level() * 100)
func exp_level_calc(p_level: int):
	const BASE = 100
	return BASE * pow(p_level - 1, 2)
	
func exp_to_next():
	return exp_level_calc(current_level + 1)
	
func get_percentage_level():
	var amount_into_curr_lvl = current_experience - exp_level_calc(current_level)
	var amount_needed_for_next = exp_to_next() -  exp_level_calc(current_level)
	var percent_done = (amount_into_curr_lvl) / (amount_needed_for_next)
	return percent_done

#region Working Bar Tween
func _on_inc_lvl_pressed() -> void:
	tween_bar(100)

func level_up():
	current_level += 1
	%ExpBar/LevelIndicator.text = "Lvl. " + str(current_level)

func tween_bar(new):
	var tween = get_tree().create_tween()
	tween.tween_property(%ExpBar, "value", new, 1)
	if new == 100: 
		tween.tween_callback(reset_tween)
		tween.finished.connect(level_up)
	
func reset_tween():
	%ExpBar.value = 0
#endregion
