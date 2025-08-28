extends Area2D

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
		print("Player entered wild grass")
		print(get_random_encounter())

func get_random_encounter() :
	if encounter_table.is_empty():
		return {}

	if randf() > encounter_rate:
		return {
		"monster_data": encounter_table[randi() % encounter_table.size()],
		"level": randi_range(min_level, max_level)
		}	
