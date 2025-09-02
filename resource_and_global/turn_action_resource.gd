class_name TurnAction extends RefCounted

var user : MonsterInstance
var target
var move : Move

func _init(user, target, move):
	self.user = user
	self.target = target
	self.move = move
