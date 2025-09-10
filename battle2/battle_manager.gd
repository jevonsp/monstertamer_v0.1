extends Node

#region Signals
signal pm1_switch(node: MonsterInstance)
signal monster_damaged(target: MonsterInstance, amount: int)
signal monster_healed(target: MonsterInstance, amount: int)
signal text_ready(
	user: MonsterInstance, 
	target: MonsterInstance, 
	move: Move, 
	damage: int, 
	effective: float, 
	weak_point: float)
signal turn_completed
signal battle_ready
signal battle_complete
signal battle_won
signal battle_lost
signal battle_fled
#endregion

#region Exports
@export var txt_mgr : Control
@export var enemy_party : Node
@export var party_scene : Node
#endregion

#region Variables
var pm1 : Node
var pm2 : Node
var em1 : Node
var em2 : Node

var is_single : bool = true
var is_wild : bool = true
var won_battle : bool = false

var turn_actions : Array[TurnAction] = []

enum BattleState {INACTIVE, START, PLAYER_CHOICE, ENEMY_CHOICE, TURN_EXECUTION, TURN_END, WIN, LOSE, FLEE}
var state : BattleState = BattleState.INACTIVE
#endregion

#region Setup
func _ready() -> void:
	pass
func _on_pm_1_switched(monster) -> void:
	pm1 = monster
	print("pm1 assigned:", pm1)
	print("pm1 known moves:", pm1.known_moves)
	connect_monster_signals()

func _on_em_1_ready(monster) -> void:
	em1 = monster
	print("em1 assigned:", em1)
	print("em1 known moves:", em1.known_moves)
	connect_monster_signals()
	_start_battle()

func connect_monster_signals():
	var monsters = [pm1, pm2, em1, em2]
	for monster in monsters:
		if monster:
			if monster == null: continue
			if not monster_damaged.is_connected(monster.lose_life):
				monster_damaged.connect(monster.lose_life)
				print("monster_damaged signals connected to ", monster)
			if not monster_healed.is_connected(monster.gain_life):
				monster_healed.connect(monster.gain_life)
				print("monster_healed signals connected ", monster)
#endregion

#region State Machine
func _set_state(new_state: BattleState) -> void:
	if state == new_state:
		return
	state = new_state
	match state:
		BattleState.INACTIVE:
			pass
		BattleState.START:
			_setup_battle()
		#BattleState.PLAYER_CHOICE:
		#BattleState.ENEMY_CHOICE:
		#BattleState.TURN_EXECUTION:
		#BattleState.TURN_END:
		#BattleState.WIN:
		#BattleState.LOSE:
		#BattleState.FLEE:
			#pass
		
#endregion

func _start_battle() -> void:
	print("start battle called")
	_set_state(BattleState.START)

func _setup_battle(): # once this is set to fire then we can remove _on_pm_1_switched/_on_em_1_switched
	connect_monster_signals()
	_set_state(BattleState.PLAYER_CHOICE)
	battle_ready.emit()

#region Turn Actions
func _on_player1_move_used(slot: int) -> void:
	var move_to_use = get_move_from_slot(slot)
	if move_to_use:
		var actor_id = 0
		var target_ids = [2]
		var action = TurnAction.new(
			actor_id, TurnAction.ActionType.MOVE, move_to_use, target_ids)
		turn_actions.append(action)
		print("Action queue:", action)
		_set_state(BattleState.ENEMY_CHOICE)
	get_enemy_action()
	execute_turn_queue()

func get_move_from_slot(slot_enum: int) -> Move:
	print("pm1 = ", pm1)
	if slot_enum >= 0 and slot_enum < pm1.known_moves.size():
		return pm1.known_moves[slot_enum]
	return null
func _on_player1_switch(node: MonsterInstance) -> void:
	if is_single: pm1_switch.emit(node)
	_on_in_battle_switch(node)

func get_enemy_action():
	var move_to_use = em1.known_moves[randi() % em1.known_moves.size()]
	if move_to_use:
		var actor_id = 2
		var target_ids = [0]
		var action = TurnAction.new(
			actor_id, TurnAction.ActionType.MOVE, move_to_use, target_ids)
		turn_actions.append(action)
		print("Action queue:", action)

func _on_in_battle_switch(monster: MonsterInstance):
	var actor_id = 0
	var action = TurnAction.new(
		actor_id, TurnAction.ActionType.SWITCH, monster, [])
	turn_actions.append(action)
	get_enemy_action()
	execute_turn_queue()

func _on_run_attempted() -> void:
	var run_chance = .33
	if randf() >= run_chance: battle_flee()
#endregion

#region Turn Execution
func execute_turn_queue():
	sort_turn_actions()
	var actions_to_execute = turn_actions.duplicate()
	turn_actions.clear()
	while actions_to_execute.size() < 1: break
	for i in range(actions_to_execute.size()):
		var action = actions_to_execute[i]
		match action.action_type:
			TurnAction.ActionType.MOVE:
				print("About to execute action ", i)
				await _execute_move(action)
				print("Action ", i, " FULLY completed")
			TurnAction.ActionType.SWITCH:
				await _execute_switch(action)
	print("All actions completed, clearing turn_actions")
	if pm1 != null or em1 != null:
		turn_completed.emit()
	print("turn_completed emitted")
	
func sort_turn_actions():
	turn_actions.sort_custom(_compare_actions)
	
func _compare_actions(a: TurnAction, b: TurnAction) -> bool:
	var a_speed = _get_actor_from_ids(a.actor_id).speed
	var b_speed = _get_actor_from_ids(b.actor_id).speed
	if a_speed == b_speed:
		return a.actor_id in [0,1]
	return a_speed > b_speed

func _execute_move(action: TurnAction) -> void:
	var actor_node = _get_actor_from_ids(action.actor_id)
	var target_nodes = _get_target_nodes(action)
	if target_nodes.size() == 0: return
	var target_node = target_nodes[0]
	var move = action.move
	if target_nodes.is_empty():
		print("No valid target for action:", action)
		return
	var move_power = roundi(_get_move_power(actor_node, target_node, action.move))
	
	print("Executing action:", action)
	print("Actor node:", actor_node)
	print("Target nodes:", target_nodes)
	print("Move Power:", move_power)
	
	if move_power > 0: monster_damaged.emit(target_node, move_power)
	else: monster_healed.emit(target_node, move_power)
	
	text_ready.emit(
		actor_node,
		target_node,
		move,
		move_power,
		_get_type_efficacy(move, target_node),
		_get_role_efficacy(move, target_node))
	print( #GPT Print Statement
	'"%s"' % actor_node.species,
	'"%s"' % target_node.species,
	'"%s"' % move.move_name,
	'"%s"' % str(move_power),
	'"%s"' % str(_get_type_efficacy(move, target_node)),
	'"%s"' % str(_get_role_efficacy(move, target_node)))
	await txt_mgr.confirmed
	print("_execute_move finished for action: ", action) 
#endregion

#region Move Calculation
func _get_target_nodes(action: TurnAction) -> Array:
	var nodes := []
	if action.target_ids.is_empty():
		if action.actor_id in [0,1]:
			nodes.append(em1) 
		if action.actor_id in [2,3]:
			nodes.append(pm1) # can add enemy targeting
	else:
		for tid in action.target_ids:
			var node = _get_actor_from_ids(tid)
			if node: nodes.append(node)
	return nodes

func _get_move_power(user, target, move):
	var base_power = _get_move_damage(user, move)
	var type_multi = _get_type_efficacy(move, target)
	var target_scalar = _get_type_efficacy(move, target)
	
	return base_power * type_multi * target_scalar

func _get_type_efficacy(move, target):
	var type = move.type
	var target_type = target.type
	var type_multi = E.get_type_multi(type, target_type)
	return type_multi
	
func _get_role_efficacy(move, target):
	print("Move role_efficacy: ", move.role_efficacy, " (type: ", typeof(move.role_efficacy), ")")
	print("Target role: ", target.role, " (type: ", typeof(target.role), ")")
	print("Converted move role: ", int(move.role_efficacy))
	print("Converted target role: ", int(target.role))

	var result = 1.5 if int(move.role_efficacy) == int(target.role) else 1.0
	print("Result: ", result)
	return result

func _get_move_damage(actor: MonsterInstance, move: Move) -> int:
	var base_damage = move.base_damage
	var role = actor.role
	var scaling_damage : int = 0
	match role:
		E.Role.TANK:
			scaling_damage = actor.defense
		E.Role.RANGE:
			scaling_damage = actor.dexterity
		E.Role.MELEE:
			scaling_damage = actor.attack
		E.Role.CLERIC:
			scaling_damage = actor.hitpoints
		E.Role.MAGE:
			scaling_damage = actor.magic
		E.Role.BARD:
			scaling_damage = actor.charm
	return base_damage + scaling_damage

func _execute_switch(action: TurnAction) -> void:
	print("put some switch animations here ")
	
func _get_actor_from_ids(id: int) -> Node:
	match id:
		0: return pm1
		1: return pm2
		2: return em1
		3: return em2
	return null
#endregion

#region Battle End
# Make signals for back and forth with txt mgr here also so the player has to page thru the dialogue
func battle_win(): # can do extra clean up logic or send packets of text to txt mgr
	battle_cleanup()
	print("win called")
	battle_won.emit()
	
func battle_lose(): # can do extra clean up logic or send packets of text to txt mgr
	battle_cleanup()
	print("lose called")
	battle_lost.emit()
	
func battle_flee(): # can do extra clean up logic or send packets of text to txt mgr
	print("battle_flee called")
	battle_cleanup()
	battle_fled.emit()
	
func battle_cleanup():
	battle_complete.emit()
	print("battle_complete emitted: ", battle_complete)
	em1 and em2 == null
#endregion
