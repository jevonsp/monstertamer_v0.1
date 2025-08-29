extends Node2D

@export var texture1 : Sprite2D
@export var texture2 : Sprite2D
@export var party : Node
@export var enemy_party : Node
@export var label : Label
@export var label2 : Label

var player_monster : Node
var enemy_monster : Node

var hp_bar = preload("res://main_scenes/battle/progress_bar.tscn")

func _ready() -> void:
	pass 

func test_battle_ready() -> void:
	# Set textures for party
	for node in party.get_children():
		if node is MonsterInstance and node.monster_data != null:
			player_monster = node
			texture1.texture = node.monster_data.texture
			label.text = node.monster_data.species_name
		else:
			print("Party node issue: ", node.name)
	
	# Set textures for enemy party
	for node in enemy_party.get_children():
		enemy_monster = node
		if node is MonsterInstance and node.monster_data != null:
			texture2.texture = node.monster_data.texture
			label2.text = node.monster_data.species_name
		else:
			print("Enemy node issue: ", node.name)
			
	set_stats()

func set_stats():
	for node in party.get_children():
		if node is MonsterInstance and node.health_component:
			var bar = hp_bar.instantiate()
			%PlayerMonster.add_child(bar)
			bar.bind_to_monster(node)
		else:
			print("Party node missing health_component or wrong type: ", node.name)

	for node in enemy_party.get_children():
		if node is MonsterInstance and node.health_component:
			var bar = hp_bar.instantiate()
			%EnemyMonster.add_child(bar)
			bar.bind_to_monster(node)
		else:
			print("Enemy node missing health_component or wrong type: ", node.name)

func _on_button_pressed() -> void:
	enemy_monster.health_component.take_damage(1)
func _on_button_2_pressed() -> void:
	enemy_monster.health_component.take_damage(5)
func _on_button_3_pressed() -> void:
	enemy_monster.health_component.take_damage(10)
func _on_button_4_pressed() -> void:
	enemy_monster.health_component.take_damage(25)

func update_hp_bar():
	pass
