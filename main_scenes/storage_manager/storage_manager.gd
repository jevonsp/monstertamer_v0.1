extends Node

@export var player : CharacterBody2D

var caught_monsters : Array[PlayerMonster] = []
var player_party : Array[PlayerMonster] = []

func _ready():
	pass

func add_monster_to_caught_monsters(caught):
	caught_monsters.append(caught)
	if player_party.size() < 6:
		player_party.append(caught)
	
func save_game():
	var saved_game:SavedGame = SavedGame.new()
	
	saved_game.player_position = player.global_position
	saved_game.caught_monsters = caught_monsters
	saved_game.player_party = player_party
	
	ResourceSaver.save(saved_game, "user://savegame.tres")
	
func load_game():
	var saved_game : SavedGame = load("user://savegame.tres") as SavedGame
	
	player.global_position = saved_game.player_position 
	caught_monsters = saved_game.caught_monsters
	player_party = saved_game.player_party
	print(player_party)

func _on_save_test_pressed() -> void:
	save_game()


func _on_load_test_pressed() -> void:
	load_game()
