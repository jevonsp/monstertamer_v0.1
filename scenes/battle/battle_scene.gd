extends Node2D

# later use signal from encounter zone to flip these, clean them up at the end
@export var is_trainer : bool = false
@export var is_double : bool = false
@export var camera : Camera2D

var allowed_to_target : bool = false
# Encounter zone will emit signal to party which then in turn makes an array and emits it to battle scene
var party : Array[MonsterInstance] = []

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("target"):
		node.disabled
	
func setup_battle():
	%Options/Fight.grab_focus()
	show_ui()
	setup_player_monsters()
	#setup_enemy_monsters()
	
func end_battle():
	is_trainer = false
	is_double  = false
	hide_ui()

func setup_player_monsters():
	for monster_instance in party:
		# display image
		pass
	
func setup_enemy_monsters(enemy_data: MonsterData, level: int):
	pass
	#var enemy_instance = MonsterInstance.new()
	#enemy_instance.init_from_data(enemy_data, level)
	#enemy_party.add_child(enemy_instance, level)
	#enemy_instance.name = "Enemy"
	
func get_target():
	allowed_to_target = true
	%Targets.visible = true
	print("attempting to grab focus")
	%Targets/Target3.grab_focus()

func show_ui():
	camera.enabled = true
	self.visible = true
	%Moves1.visible = false
	%Moves2.visible = false
	# if its a singble battle
	if !is_double:
		%TopNames.visible = false
		%TopBars.visible = false
		%DoubleBattle.visible = false
		%SingleBattle.visible = true
	# if its a double battle
	if is_double:
		%TopNames.visible = true
		%TopBars.visible = true
		%DoubleBattle.visible = true
		%SingleBattle.visible = false
	
func hide_ui():
	self.visible = false
	camera.enabled = false
	
