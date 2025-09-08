class_name TurnAction
extends RefCounted

enum ActionType {MOVE, SWITCH, ITEM, RUN}

var actor_id : int
var action_type : ActionType

# Payloads
var move : Move = null
var item_id : int = -1
var switch_id : int = -1
var target_ids : Array = []

func _init(_actor_id: int, _action_type: ActionType, _payload = null, _target_ids := []):
	actor_id = _actor_id
	action_type = _action_type
	target_ids = _target_ids
	if target_ids.is_empty():
		target_ids.append(0)

	if action_type == ActionType.MOVE:
		if _payload is Move:
			move = _payload
		else:
			push_warning("TurnAction MOVE expects a Move instance.")
	elif action_type == ActionType.ITEM:
		if typeof(_payload) == TYPE_INT:
			item_id = _payload
		else:
			push_warning("TurnAction ITEM expects an int ID.")
	elif action_type == ActionType.SWITCH:
		if typeof(_payload) == TYPE_INT:
			switch_id = _payload
		else:
			push_warning("TurnAction SWITCH expects an int ID.")
	elif action_type == ActionType.RUN:
		pass  # no payload needed

func _to_string() -> String:
	var move_name_str = "null"
	if move != null:
		move_name_str = move.move_name
	return "Action(%s, actor=%d, move=%s, item=%d, switch=%d, targets=%s)" % [
		ActionType.keys()[action_type], actor_id, move_name_str, item_id, switch_id, str(target_ids)]
