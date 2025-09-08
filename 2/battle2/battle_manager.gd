extends Node

signal pm1_move_used

var pm1 : Node
var pm2 : Node
var em1 : Node
var em2 : Node

var is_single : bool = true

var turn_actions : Array[TurnAction] = []

func _on_pm_1_switched(monster) -> void:
	pm1 = monster

func _on_player1_move_used(slot: int) -> void:
	print("turn this enum into a move")
	#var actor_id = 0
	#var target_ids = [0]
	#var action = TurnAction.new(
		#actor_id, TurnAction.ActionType.MOVE, slot, target_ids
	#)
	#turn_actions.append(action)
	#print("Action queue:", action)
	#if is_single: pm1_move_used.emit()
		
func _on_player1_switch(slot: int) -> void:
	if is_single: pm1_move_used.emit()
	
func _on_pm_1_move_used() -> void:
	execute_turn_queue()
	
func execute_turn_queue():
	for action in turn_actions:
		match action.action_type:
			TurnAction.ActionType.MOVE:
				_execute_move(action)
			TurnAction.ActionType.SWITCH:
				_execute_move(action)
			TurnAction.ActionType.ITEM:
				_execute_move(action)
			TurnAction.ActionType.RUN:
				_execute_move(action)
	turn_actions.clear()
	
func _execute_move(action: TurnAction) -> void:
	var actor_node = _get_actor_from_ids(action.actor_id)
	var target_nodes = _get_target_nodes(action)
	
	print("Executing action:", action)
	print("Actor node:", actor_node)
	print("Target nodes:", target_nodes)

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
	
func _execute_switch(action: TurnAction) -> void:
	pass
	
func _get_actor_from_ids(id: int) -> Node:
	match id:
		0: return pm1
		1: return pm2
		2: return em1
		3: return em2
	return null
	
