extends CharacterBody2D

signal moved_to_tile(world_position: Vector2)

@export var camera : Camera2D

enum State {IDLE, MOVING, DISABLED}

const TILE_SIZE :Vector2 = Vector2(32, 32)
const MOVE_SPEED: float = 200.0

var state : State = State.IDLE

func _ready() -> void:
	add_to_group("player")
	add_to_group("player_elements")
	
func _physics_process(delta: float) -> void:
	if state != State.IDLE:
		return
	if Input.is_action_pressed("up"):
		_move(Vector2.UP)
	if Input.is_action_pressed("down"):
		_move(Vector2.DOWN)
	if Input.is_action_pressed("left"):
		_move(Vector2.LEFT)
	if Input.is_action_pressed("right"):
		_move(Vector2.RIGHT)

func _move(direction : Vector2) -> void:
	if state != State.IDLE:
		return
	if _is_valid_move(direction):
		_execute_tween(direction)
	
func _is_valid_move(direction : Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = global_position + direction * TILE_SIZE
	var result =  space_state.intersect_point(query)
	return result.is_empty()
	
func _execute_tween(direction : Vector2) -> void:
	state = State.MOVING
	var target_pos = global_position + direction * TILE_SIZE
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, .2)
	await tween.finished
	state = State.IDLE
	moved_to_tile.emit(global_position)
