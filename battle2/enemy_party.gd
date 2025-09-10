extends Node

signal enemy_added(monster)
signal no_enemy_monsters_left
signal emit_exp(amount: int)

@export var monster_updater : Node

var alive

func _on_battle_monster_recieved(monster: MonsterInstance) -> void:
	print("eparty got signal")
	print("monster: ", monster)
	add_child(monster)
	enemy_added.emit(monster)

func handle_monster_death(monster) -> void:
	emit_exp.emit(get_exp_amount(monster))
	remove_from_party(monster)
	alive = 0
	for child in get_children():
		if !child.is_fainted: alive += 1
	if alive == 0: no_enemy_monsters_left.emit()
	
func get_exp_amount(monster) -> int:
	const BASE = 50
	return 50 * monster.level
	
func remove_from_party(monster):
	monster.queue_free()
