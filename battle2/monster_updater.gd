extends Node

signal pm1_switched(node: MonsterInstance)
signal em1_switched(node: MonsterInstance)

@export var pm1 : Node
@export var pm2 : Node
@export var em1 : Node
@export var em2 : Node

func update_player_monster(monster: MonsterInstance):
	pm1.assign_monster(monster)
	pm1_switched.emit(monster)

# get signal from enemy party and move change monster to this one
func update_enemy_monster(monster: MonsterInstance):
	print("assigning em1")
	em1.assign_monster(monster)
	print("em1: ", em1)
	em1_switched.emit(monster)
	

func _hide_children() -> void:
	for node in get_children():
		node.visible = false
		
func _show_children() -> void:
	for node in get_children():
		node.visible = true
