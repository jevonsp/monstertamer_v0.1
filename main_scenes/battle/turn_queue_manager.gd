extends Node
@export_subgroup("Nodes")
@export var battle_scene : Node2D
@export var txt_mgr : Control
@export var ui_mgr : Control
@export var battle_calc : Node
# Nodes
var party : Node
var enemy_party : Node

var turn_queue : Array[Node] = []
var turn_actions : Array[TurnAction]

var tqm_party_slots : Array[Node] = []
var tqm_enemy_slots : Array[Node] = []

var player_monster1 : Node
var player_monster2 : Node
var enemy_monster1 : Node
var enemy_monster2 : Node
# gets signal from enemy party
var is_single : bool = false

func _ready():
	var battle_scene = get_parent()
	party = battle_scene.get_parent().get_node("Party")
	party.connect("party_slots_updated", Callable(self, "_on_party_slots_updated"))
	enemy_party = battle_scene.get_parent().get_node("EnemyParty")
	enemy_party.connect("monsters_ready", Callable(self, "_on_enemy_party_slots_update"))
	
func _on_enemy_party_is_double() -> void:
	is_single = false
	
func _on_party_slots_updated() -> void:
	tqm_party_slots.clear()
	for slot in party.party_slots:
		if slot.node:
			tqm_party_slots.append(slot.node)
func _on_enemy_party_slots_update() -> void:
	tqm_enemy_slots.clear()
	for enemy in enemy_party.get_children():
		tqm_enemy_slots.append(enemy)
	
func make_turn_queue():
	if is_single:
		make_singles_queue()
	else:
		make_doubles_queue()
	
func sort_turn_queue():
	turn_queue.sort_custom(Callable(self, "compare_speed"))
	for monster in turn_queue:
		monster.participated = true
func compare_speed(a, b): # Helper
	return b.stats_component.current_speed - a.stats_component.current_speed

func make_singles_queue():
	player_monster1 = tqm_party_slots[0].node
	turn_queue.append(player_monster1)
	enemy_monster1 = tqm_enemy_slots[0]
	turn_queue.append(enemy_monster1)
func make_doubles_queue():
	player_monster1 = tqm_party_slots[0].node
	turn_queue.append(player_monster1)
	enemy_monster1 = tqm_enemy_slots[0]
	turn_queue.append(enemy_monster1)
	
	player_monster2 = tqm_party_slots[1].node
	turn_queue.append(player_monster2)
	enemy_monster2 = tqm_enemy_slots[1]
	turn_queue.append(enemy_monster2)

func queue_move(user, target, move):
	var action = TurnAction.new(user, target, move)
	turn_actions.append(action)
	if all_moves_chosen():
		execute_turn()
func all_moves_chosen():
	if is_single:
		return turn_actions.size() == 1
	else:
		return turn_actions.size() == 2
func execute_turn():
	ui_mgr.buttons_off(true)
	enemy_choose_moves()
	sort_actions()
	for action in turn_actions:
		await resolve_action(action)
	turn_actions.clear()
	ui_mgr.buttons_off(false)
	ui_mgr.show_button_state(ui_mgr.ChoiceState.CHOICE1)
	sort_turn_queue()
func enemy_choose_moves():
	if is_single:
		var enemy = enemy_monster1
		var move = enemy_monster1.known_moves.pick_random()
		var target = get_default_target(enemy)
		queue_move(enemy, target, move)
	else:
		for i in range(2):
			var enemy = enemy_party.get_child(i)
			var move = enemy.known_moves.pick_random()
			var target = get_default_target(enemy)
			queue_move(enemy, target, move)
			
func get_default_target(user):
	if user in [player_monster1, player_monster2]:
		return enemy_monster1
	else:
		return player_monster1
func sort_actions():
	turn_actions.sort_custom(Callable(self, "compare_turn_actions"))
func compare_turn_actions(a, b): # Helper
	var index_a = turn_queue.find(a.user)
	var index_b = turn_queue.find(b.user)
	return index_a - index_b
	
func resolve_action(action):
	var user = action.user
	var target = action.target
	var move = action.move
	if target:
		var dmg = battle_calc.calc_damage(user, target, move)
		target.health_component.take_damage(dmg)
		
		await txt_mgr.show_text("%s hit %s \nwith %s for %d damage" % [
				user.monster_name, target.monster_name, move.name, dmg])
		
		if target.health_component.is_dead():
			remove_from_battle(target)

func remove_from_battle(target):
	if target.health_component.is_dead():
		print("%s has fainted" % target.monster_data.species_name)
		if target in [enemy_monster1, enemy_monster2]:
			var xp = target.get_xp_yield()
			award_xp(xp)
			target.queue_free()
			if enemy_party.get_child_count() <= 1:
				battle_scene.end_battle()
				for slot in party.party_slots:
					slot.node.participated = false
		if target in [player_monster1, player_monster2]:
			var available = []
			for slot in party.party_slots:
				var mon = slot.node
				if mon != null and !mon.health_component.is_dead():
					available.append(mon)
			if available.size() > 0:
				# Need Party Selection Screen
				print("choose a monster")
				battle_scene.end_battle()
			else:
				print("you lost")
				battle_scene.end_battle()

func award_xp(xp: int):
	for slot in party.party_slots:
		if slot.node.participated:
			slot.pm.experience += xp
