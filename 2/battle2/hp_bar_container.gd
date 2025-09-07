extends Node2D

@export var bar : TextureProgressBar

var monster: MonsterInstance

func assign_monster(m: MonsterInstance) -> void:
	monster = m
