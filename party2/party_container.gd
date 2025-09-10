extends Node

signal no_player_monsters_left

@export var party : Node2D

var in_battle_monsters : Array[MonsterInstance]
var alive

func handle_monster_death(monster):
	alive = 0
	for child in get_children():
		if !child.is_fainted: alive += 1
	if alive == 0: no_player_monsters_left.emit()
	
func start_exp_tracking():
	in_battle_monsters.append(party.party_array[0])
func mark_for_exp(monster):
	in_battle_monsters.append(monster)
func end_exp_tracking():
	in_battle_monsters.clear()
func give_exp(amount):
	for monster in in_battle_monsters:
		monster.gain_exp(amount/in_battle_monsters.size())
