class_name TrainerComponent
extends Area2D

@export_subgroup("Party")
@export var party : Array[MonsterData]
@export var party_levels : Array[int]

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

func _on_player_moved_to_tile(world_position: Vector2):
	if is_position_in_area(world_position):
		print("Player entered Trainer sight")
