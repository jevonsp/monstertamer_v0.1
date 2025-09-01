extends Node

signal need_instance
signal make_party_instance

@export_subgroup("Nodes")
@export var player : CharacterBody2D
@export var capture_manager : Node
@export var party : Node

var caught_monsters : Array[PlayerMonster] = []
var player_party : Array[PartySlot] = []

func _ready():
	pass

func add_monster_to_caught_monsters(caught : PlayerMonster):
	caught_monsters.append(caught)
	if player_party.size() < 6:
		player_party.append(caught)

func swap_party_slot(i: int, j: int):
	pass
	
func move_party_members(index_a: int, index_b: int):
	pass

func get_instance(pm):
	need_instance.emit(pm)
	
func save_game():
	var saved_game:SavedGame = SavedGame.new()
	saved_game.player_position = player.global_position
	saved_game.caught_monsters = caught_monsters
	
	var party_pms: Array[PlayerMonster] = []
	for slot in player_party:
		party_pms.append(slot.pm)
	saved_game.player_party = party_pms
	ResourceSaver.save(saved_game, "user://savegame.tres")
	
func load_game():
	var saved_game : SavedGame = load("user://savegame.tres") as SavedGame
	player.global_position = saved_game.player_position 
	caught_monsters = saved_game.caught_monsters
	
	player_party.clear()
	for pm in saved_game.player_party:
		var new_instance = capture_manager.monster_factory.create_from_pm(pm)
		var slot = PartySlot.new
		slot.pm = pm
		slot.node = new_instance
		player_party.append(slot)
		party.add_child(new_instance)
	print(player_party)

func _on_save_test_pressed() -> void:
	save_game()

func _on_load_test_pressed() -> void:
	load_game()
