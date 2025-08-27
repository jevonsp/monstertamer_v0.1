extends Node2D

# later use signal from encounter zone to flip these, clean them up at the end
@export var is_trainer : bool = false
@export var is_double : bool = false
@export var camera : Camera2D

var items_open : bool = false

func _physics_process(delta: float) -> void:
	if items_open and Input.is_action_just_pressed("no"):
		%Items.visible = false

func _ready() -> void:
	setup_battle()

func setup_battle():
	show_ui()
	
func end_battle():
	is_trainer = false
	is_double  = false

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
	
func _on_fight_pressed() -> void:
	%Options.visible = false
	%Moves1.visible = true

func _on_item_pressed() -> void:
	%Items.visible = true
	items_open = true
