extends Node2D

@export_subgroup("Nodes")
@export var player : CharacterBody2D
@export var battle : Node2D
@export var party : Node2D
@export var encounter_zones : Node
@export var healing_zones : Node

func _ready() -> void:
	#region Connections
	for zone in encounter_zones.get_children():
		if !zone.battle_monster_ready.is_connected(battle.eparty._on_battle_monster_recieved):
			zone.battle_monster_ready.connect(battle.eparty._on_battle_monster_recieved)
			print("Connected ", zone, " to battle eparty")
	for zone in encounter_zones.get_children():
		if !zone.req_player_stop.is_connected(player._pause_player_action):
			zone.req_player_stop.connect(player._pause_player_action)
			print("Connected player encounters")
	for zone in healing_zones.get_children():
		if !player.ask_for_healing.is_connected(zone.send_healing):
			player.ask_for_healing.connect(zone.send_healing)
			print("Connected player healing")
	for zone in healing_zones.get_children():
		if !zone.full_heal.is_connected(party.party_container.heal_party):
			zone.full_heal.connect(party.party_container.heal_party)
			print("zones connected to party")
	if battle.eparty:
		if !battle.eparty.no_enemy_monsters_left.is_connected(battle.battle_mgr.battle_win):
			battle.eparty.no_enemy_monsters_left.connect(battle.battle_mgr.battle_win)
			print("Connected enemy party to battle manager")
	if battle.eparty and party.party_container:
		if !battle.eparty.emit_exp.is_connected(party.party_container.give_exp):
			battle.eparty.emit_exp.connect(party.party_container.give_exp)
			print("Connected EXP flow")
	if party.party_container:
		if !party.party_container.no_player_monsters_left.is_connected(battle.battle_mgr.battle_lose):
			party.party_container.no_player_monsters_left.connect(battle.battle_mgr.battle_lose)
			print("Connected player party to battle manager")
	if battle.battle_mgr:
		if !battle.battle_mgr.battle_complete.is_connected(player._resume_player_action):
			battle.battle_mgr.battle_complete.connect(player._resume_player_action)
			print("connected battle mgr to player resume")
	#endregion
	
func _process(_delta: float) -> void:
	var viewport_size = Vector2(640, 360)
	if battle.visible: battle.global_position = player.global_position - (viewport_size / 2)
	if party.visible: party.global_position = player.global_position - (viewport_size / 2)
