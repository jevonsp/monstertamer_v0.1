extends Node

signal pm1_switched

@export var pm1 : Node
@export var pm2 : Node
@export var em1 : Node
@export var em2 : Node

func update_player_monster(monster: MonsterInstance):
	pm1.assign_monster(monster)
	pm1_switched.emit(monster)

func update_enemy_monster(monster: MonsterInstance):
	em1.assign_monster(monster)

func _hide_children() -> void:
	for node in get_children():
		node.visible = false
		
func _show_children() -> void:
	for node in get_children():
		node.visible = true
