class_name EncounterEvent extends Resource

@export var monster_data : MonsterData
@export var level : int
@export var is_single : bool

func _init(p_monster_data: MonsterData = null, p_level: int = 1) -> void:
	monster_data = p_monster_data
	level = p_level
