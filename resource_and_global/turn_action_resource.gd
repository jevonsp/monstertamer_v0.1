class_name TurnAction extends RefCounted

var user : MonsterInstance
var target
var move : Move

func _init(p_user, p_target, p_move):
	user = p_user
	target = p_target
	move = p_move
