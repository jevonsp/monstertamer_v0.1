extends CharacterBody2D

signal moved_to_tile(world_position: Vector2)
signal ask_for_healing
signal player_party_request

@export var camera : Camera2D
@export var ray2d : RayCast2D
@export var battle_scene : Node

enum State {IDLE, MOVING, DISABLED}

const TILE_SIZE :Vector2 = Vector2(32, 32)
const MOVE_SPEED: float = 200.0

var state : State = State.IDLE
var in_battle : bool = false

var can_heal : bool = false
var healing_target : Area2D = null

func _ready() -> void:
	add_to_group("player")
	add_to_group("player_elements")
	_rotate_look_direction(Vector2.DOWN)
	camera.make_current()
	
func _physics_process(_delta: float) -> void:
	if state != State.IDLE:
		return
	if state == State.DISABLED:
		return
	if Input.is_action_pressed("menu"):
		_open_menu()
	if Input.is_action_pressed("up"):
		_move(Vector2.UP)
		_rotate_look_direction(Vector2.UP)
	if Input.is_action_pressed("down"):
		_move(Vector2.DOWN)
		_rotate_look_direction(Vector2.DOWN)
	if Input.is_action_pressed("left"):
		_move(Vector2.LEFT)
		_rotate_look_direction(Vector2.LEFT)
	if Input.is_action_pressed("right"):
		_move(Vector2.RIGHT)
		_rotate_look_direction(Vector2.RIGHT)
	
	_check_ray2d_collision()
	
	if Input.is_action_pressed("yes") and can_heal:
		print("want to heal")
		ask_for_healing.emit()

func _move(direction : Vector2) -> void:
	if state != State.IDLE:
		return
	if _is_valid_move(direction):
		_execute_tween(direction)

func _rotate_look_direction(direction: Vector2):
	ray2d.target_position = Vector2(32, 0)
	ray2d.rotation = direction.angle()

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
	if state == State.MOVING:
		state = State.IDLE
		moved_to_tile.emit(global_position)
	
func _check_ray2d_collision():
	if ray2d.is_colliding():
		var collider = ray2d.get_collider()
		can_heal = collider != null and collider.is_in_group("healing")
	else:
		can_heal = false

func _resume_player_action():
	in_battle = false
	state = State.IDLE
func _pause_player_action():
	print("recieved disable req")
	state = State.DISABLED

func _open_menu():
	player_party_request.emit()
	_pause_player_action()
	
func _close_menu():
	Input.action_release("menu")
	Input.action_release("yes")
	Input.action_release("no")
	camera.make_current()
	if in_battle:
		return
	_resume_player_action()

func _on_full_battle_remake_in_battle_true() -> void:
	in_battle = true
