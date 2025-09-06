extends Node2D

@export var monster_data : MonsterData
@export var monster_factory : Node

var monster : Node

func _ready():
	monster = monster_factory.create_monster(monster_data, 10)
	add_child(monster)

func _on_inc_exp_pressed() -> void:
	monster.gain_exp(1000)

func _on_inc_lvl_pressed() -> void:
	monster.level_up()

func tween_bar(old, new):
	pass
