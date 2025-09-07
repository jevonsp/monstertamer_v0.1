extends Node2D

var assigned_monster : MonsterInstance

func assign_monster(monster: MonsterInstance):
	assigned_monster = null
	assigned_monster = monster
	update_slot()
	
func update_slot():
	if !assigned_monster:
		return
	$NameLabel.text = assigned_monster.species
	$Image.texture = assigned_monster.image
	$BattleHpBar.assign_monster(assigned_monster)
	$BattleExpBar.assign_monster(assigned_monster)
