extends Node

signal ask_party(pm: PlayerMonster)

@export_subgroup("Nodes")
@export var player : CharacterBody2D
@export var capture_manager : Node
@export var party : Node
@export var monster_factory : Node

var caught_monsters : Array[PlayerMonster] = []
var party_slots : Array[PlayerMonster] = []

func _ready():
	pass

# From Monster Adder
func get_starter(pm : PlayerMonster):
	print("monster get")
	add_monster_to_caught_monsters(pm)
# From Capture Manager
func add_monster_to_caught_monsters(caught : PlayerMonster):
	print("added to pm")
	caught_monsters.append(caught)
	ask_party.emit(caught)

#func get_instance(pm):
	#need_instance.emit(pm)
	
func save_game():
	var saved_game:SavedGame = SavedGame.new()
	saved_game.player_position = player.global_position
	saved_game.caught_monsters = caught_monsters
	
	var party_pms: Array[PlayerMonster] = []
	for slot in party_slots:
		party_pms.append(slot.pm)
	saved_game.player_party = party_pms
	ResourceSaver.save(saved_game, "user://savegame.tres")
	
func load_game():
	var saved_game : SavedGame = load("user://savegame.tres") as SavedGame
	player.global_position = saved_game.player_position 
	caught_monsters = saved_game.caught_monsters
	
	party_slots.clear()
	for pm in saved_game.player_party:
		var new_instance = capture_manager.monster_factory.create_from_pm(pm)
		var slot = PartySlot.new
		slot.pm = pm
		slot.node = new_instance
		party_slots.append(slot)
		party.add_child(new_instance)
	print(party_slots)

func _on_save_test_pressed() -> void:
	save_game()

func _on_load_test_pressed() -> void:
	load_game()
