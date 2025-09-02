extends Node

signal party_slots_updated

@export_subgroup("Nodes")
@export var monster_factory : Node
@export var battle_scene : Node
@export var party_list : Node2D

var party_slots : Array[PartySlot] = []

func _ready() -> void:
	pass

func heal_party():
	print("got asked for healing")
	for monster in get_children():
		monster.health_component.heal()

func check_party_slots(caught):
	if party_slots.size() < 6:
		var new_instance = monster_factory.create_from_pm(caught)
		add_child(new_instance)
		print("added party member")
		make_party_slot(caught, new_instance)
		update_party_slots()
		print("made party slot")

func make_party_slot(pm, node):
	var slot = PartySlot.new()
	slot.pm = pm
	slot.node = node
	party_slots.append(slot)

# connected through editor to PartyList
func update_party_slots():
	print("update called")
	for slot in party_slots:
		if slot.node and slot.pm:
			slot.pm.level = slot.node.stats_component.level
			slot.pm.max_hp = slot.node.health_component.max_hp
			slot.pm.current_hp = slot.node.health_component.current_hp 
			slot.pm.experience = slot.node.experience
			slot.pm.moves = slot.node.known_moves.duplicate()
	party_slots_updated.emit()

func _on_button_pressed() -> void:
	for monster in get_children():
		monster.level_up()
	update_party_slots()
