extends Node2D

@export_subgroup("Nodes")
@export var battle : Node2D
@export var encounter_zones : Node
@export var player : CharacterBody2D

func _ready() -> void:
	for zone in encounter_zones.get_children():
		if !zone.battle_monster_ready.is_connected(battle._on_battle_monster_recieved):
			zone.battle_monster_ready.connect(battle._on_battle_monster_recieved)
			print("Connected ", zone, " to battle")
	for zone in encounter_zones.get_children():
		if !zone.req_player_stop.is_connected(player._pause_player_action):
			zone.req_player_stop.connect(player._pause_player_action)
			print("Connected player")
