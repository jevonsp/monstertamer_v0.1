class_name MonsterData
extends Resource

enum Type {
	FIRE, WATER, GRASS
}

enum Role {
	MELEE, RANGE, TANK
}
@export var species_name : String
@export var texture : Texture2D

@export_subgroup("Type and Role")
@export var type : Type
@export var role : Role

@export_subgroup("Stats")
@export var base_hp : int = 10
@export var base_speed : int = 1
@export var base_attack : int = 1
@export var base_defense : int = 1
@export var base_dexterity : int = 1

@export_subgroup("Learnset")
@export var learnable_moves: Array[Move]
@export var learn_levels: Array[int]
