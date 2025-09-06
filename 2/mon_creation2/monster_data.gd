class_name MonsterData extends Resource

# This functions like a dex entry, all of of its info is copied into the node
@export_subgroup("Basic Info")
@export var species : String = ""
@export var image : Texture2D
@export var type : E.Type = E.Type.NONE
@export var role : E.Role = E.Role.MELEE

@export_subgroup("Stat Table")
@export var growth_rate : E.GrowthRate = E.GrowthRate.MEDIUM

@export_subgroup("Moves Table")
