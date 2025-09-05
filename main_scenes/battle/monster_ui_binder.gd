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

var ui_slots = {}

var hp_bar_scene = preload("res://main_scenes/battle/progress_bar.tscn")

#DEBUG#
func _enter_tree() -> void:
	if tqm_mgr:
		if not tqm_mgr.battle_monster_display_req.is_connected(_on_battle_monster_display_req):
			tqm_mgr.battle_monster_display_req.connect(_on_battle_monster_display_req)
			print("✅ UI connected to TQM signal:", tqm_mgr)

func _ready() -> void:
	ui_slots = {
	"player1": {"texture": player_texture1, "name": player_name1, "box": player_box1},
	"player2": {"texture": player_texture2, "name": player_name2, "box": player_box2},
	"enemy1": {"texture": enemy_texture1, "name": enemy_name1, "box": enemy_box1},
	"enemy2": {"texture": enemy_texture2, "name": enemy_name2, "box": enemy_box2}}
	if not tqm_mgr.battle_monster_display_req.is_connected(_on_battle_monster_display_req):
		tqm_mgr.battle_monster_display_req.connect(_on_battle_monster_display_req)
	#DEBUG#
	print("✅ UI ready, slots set up:", ui_slots.keys())
#Connected from tqm to mui
func _on_battle_monster_display_req(monster):
	#DEBUG#
	print("📩 UI received monster:", monster)
	var slot = monster.get_meta("ui_slot")
	#DEBUG#
	print("➡️ Slot from monster meta:", slot)
	if not slot:
		#DEBUG#
		print("❌ No slot meta found on monster")
		return
	var ui = ui_slots.get(slot)
	ui["texture"].texture = monster.monster_data.texture
	ui["name"].text = monster.monster_name
	if not monster.has_meta("HPBar"):
		var bar = hp_bar_scene.instantiate()
		ui.box.add_child(bar)
		bar.bind_to_monster(monster)
		monster.set_meta("HPBar", bar)
		
func hide_health_bars():
	for node in tqm_mgr.turn_queue:
		if node.has_meta("HPBar"):
			var bar = node.get_meta("HPBar")
			bar.queue_free()
	for node in tqm_mgr.turn_queue:
		if node.has_meta("HPBar"):
			node.remove_meta("HPBar")
			
