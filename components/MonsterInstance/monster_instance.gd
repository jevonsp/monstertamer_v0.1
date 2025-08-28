class_name MonsterInstance
extends Node

@export var monster_data : MonsterData

var stats_component : StatsComponent
var current_level : int
var moves_component : MovesComponent
var known_moves : Array[Move]


func _ready() -> void:
	create_monster()
	print(stats_component.base_speed)
	
func create_monster():
	stats_component = StatsComponent.new()
	var encounter = EncounterEvent.new(monster_data, 1)
	stats_component.setup_monster_from_data(encounter)
