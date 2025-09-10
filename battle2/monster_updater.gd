extends Node

signal pm1_updated(monster: MonsterInstance)
signal em1_updated(monster: MonsterInstance)
signal pm1_moves_reordered

@export var pm1 : Node # Slots
@export var pm2 : Node
@export var em1 : Node
@export var em2 : Node

func update_player_monster(monster: MonsterInstance):
	print("assigning pm1")
	pm1.assign_monster(monster)
	pm1_updated.emit(monster)

func on_enemy_monster_recieved(monster) -> void:
	print("got em1 signal")
	update_enemy_monster(monster)

func update_enemy_monster(monster: MonsterInstance):
	print("assigning em1")
	em1.assign_monster(monster)
	print("em1: ", em1)
	em1_updated.emit(monster)
	
func _hide_children() -> void:
	for node in get_children():
		node.visible = false
		
func _show_children() -> void:
	for node in get_children():
		node.visible = true
