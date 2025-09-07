extends Node2D

var assigned_monster : MonsterInstance

func assign_monster(monster: MonsterInstance):
	print("monster assigned")
	assigned_monster = monster
	update_slot()
	
func update_slot():
	if !assigned_monster:
		return
	$NameLabel.text = assigned_monster.species
	$Icon.texture = assigned_monster.image
	$GenderIcon.texture = assigned_monster.gender_icon
	print("Assigned gender icon:", assigned_monster.gender_icon)
	$PartyHpBar.assign_monster(assigned_monster)
	$PartyExpBar.assign_monster(assigned_monster)

func clear_slot():
	$NameLabel.text = ""
	$Icon.texture = null
	#$HpBarContainer.
	#$ExpBarContainer.
