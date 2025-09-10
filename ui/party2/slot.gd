extends Node2D

@export var party_hp_bar : Node2D
@export var party_exp_bar : Node2D

var assigned_monster : MonsterInstance

func _ready() -> void:
	pass

func assign_monster(monster: MonsterInstance):
	print("monster assigned")
	assigned_monster = monster
	update_slot()
	
func update_slot():
	if !assigned_monster:
		visible = false
		return
	self.visible = true
	$NameLabel.text = assigned_monster.monster_name
	print("monster_name: ", assigned_monster.monster_name)
	$Icon.texture = assigned_monster.image
	$GenderIcon.texture = assigned_monster.gender_icon
	print("Assigned gender icon:", assigned_monster.gender_icon)
	party_hp_bar.assign_monster(assigned_monster)
	party_exp_bar.assign_monster(assigned_monster)
