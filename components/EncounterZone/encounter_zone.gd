extends Area2D

signal random_encounter(event : EncounterEvent)

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
		var encounter = get_random_encounter()
		if encounter:
			random_encounter.emit(encounter)

func roll_encounter() -> bool:
	return encounter_rate > randf()
	
func get_random_encounter() -> EncounterEvent:
	if roll_encounter():
		return build_encounter()
	return null
	
func build_encounter() -> EncounterEvent:
	var event = EncounterEvent.new()
	event.monster_data = encounter_table[randi() % encounter_table.size()]
	event.level = randi_range(min_level, max_level)
	return event
