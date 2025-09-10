extends Node2D

var assigned_monster : MonsterInstance
@export var lvl_label : Label

func assign_monster(monster: MonsterInstance):
	print("assign_monster called")
	assigned_monster = null
	assigned_monster = monster
	update_slot()
	
func update_slot():
	if !assigned_monster:
		return
	$NameLabel.text = assigned_monster.monster_name
	$Image.texture = assigned_monster.image
	$BattleHpBar.assign_monster(assigned_monster)
	var exp_bar = get_node_or_null("BattleExpBar")
	if exp_bar: $BattleExpBar.assign_monster(assigned_monster)
	if lvl_label: lvl_label.text = "Lvl. %d" % assigned_monster.level
	
