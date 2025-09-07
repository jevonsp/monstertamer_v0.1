extends Node2D

var assigned_monster : MonsterInstance

func assign_monster(monster: MonsterInstance):
	assigned_monster = monster
	update_slot()
	
func update_slot():
	if !assigned_monster:
		return
	$NameLabel.text = assigned_monster.species
	$Icon.texture = assigned_monster.image
	$HpBarContainer.assign_monster(assigned_monster)
	$ExpBarContainer.assign_monster(assigned_monster)

func clear_slot():
	$NameLabel.text = ""
	$Icon.texture = null
	#$HpBarContainer.
	#$ExpBarContainer.
