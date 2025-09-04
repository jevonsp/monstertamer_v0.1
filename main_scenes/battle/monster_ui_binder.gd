extends Node

@export var tqm_mgr : Node

@export_subgroup("VBoxes")
@export var player_box1 : VBoxContainer
@export var player_box2 : VBoxContainer
@export var enemy_box1 : VBoxContainer
@export var enemy_box2 : VBoxContainer
@export_subgroup("Monster Texture")
@export var player_texture1 : TextureRect
@export var player_texture2 : TextureRect
@export var enemy_texture1 : TextureRect
@export var enemy_texture2 : TextureRect
@export_subgroup("Monster Names")
@export var player_name1 : Label
@export var player_name2 : Label
@export var enemy_name1 : Label
@export var enemy_name2 : Label

# ui dict
var ui_slots = {
	"player1": {"texture": player_texture1, "name": player_name1},
	"player2": {"texture": player_texture2, "name": player_name2},
	"enemy1": {"texture": enemy_texture1, "name": enemy_name1},
	"enemy2": {"texture": enemy_texture2, "name": enemy_name2}
}

func _ready() -> void:
	pass

func _on_battle_monster_display_req(monster):
	var slot = monster.get_meta("ui_slot")
	if not slot: return
	var ui = ui_slots[slot]
	ui["texture"].texture = monster.monster_data.texture
	ui["name"].text = monster.monster_name
