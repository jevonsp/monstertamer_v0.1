class_name MonsterData extends Resource

# This functions like a dex entry, all of of its info is copied into the node
@export_subgroup("Basic Info")
@export var species : String = ""
@export var image : Texture2D
@export var type : E.Type
@export var role : E.Role
# 1 = Male 2 = Female 4 = None add together for options. Gendered = 3, for example.
@export var allowed_genders : int = E.Gender.MALE | E.Gender.FEMALE 
@export_subgroup("Starting Stats")
@export var base_hitpoints = 10
@export var base_speed = 0
@export var base_attack = 0
@export var base_defense = 0
@export var base_dexterity = 0
@export var base_magic = 0
@export var base_charm = 0
@export_subgroup("Stat Table")
@export var growth_rate : E.GrowthRate = E.GrowthRate.MEDIUM
# a float so the amount you get per level can be less than 1
@export var hitpoints_growth : float = 1.0 
@export var speed_growth : float = 1.0
@export var attack_growth : float = 1.0
@export var defense_growth : float = 1.0
@export var dexterity_growth : float = 1.0
@export var magic_growth : float = 1.0
@export var charm_growth : float = 1.0
@export_subgroup("Moves Table")
@export var levels : Array[int]
@export var moves : Array[Move]
