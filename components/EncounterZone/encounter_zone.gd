extends Area2D

signal random_encounter(event : EncounterEvent)
signal battle_needs_focus

@export var enemy_party : Node

@export_subgroup("Encounters")
@export var encounter_table : Array[MonsterData]
@export var encounter_rate : float
@export var min_level : int
@export var max_level : int

func _ready() -> void:
	pass

func is_position_in_area(check_position: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = check_position
	query.collision_mask = collision_mask
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var results = space_state.intersect_point(query)
	for result in results:
		if result.collider == self:
			return true
	return false

# Connected via editor signal to player
func _on_player_moved_to_tile(world_position: Vector2):
	if is_position_in_area(world_position):
		if randf() < encounter_rate:
			if enemy_party:
				random_encounter.emit(constuct_wild_encounter())

func constuct_wild_encounter() -> EncounterEvent:
	var monster_data = get_monster_in_range()
	var level = get_level_in_range()
	var event := EncounterEvent.new()
	event.monster_data = monster_data
	event.level = level
	return (event)

func get_monster_in_range():
	var monster_data = encounter_table.pick_random()
	return monster_data
	
func get_level_in_range():
	var level = range(min_level, max_level + 1).pick_random()
	return level
