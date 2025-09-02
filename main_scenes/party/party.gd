extends Node

@export_subgroup("Nodes")
@export var monster_factory : Node
@export var battle_scene : Node

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
		print("made party slot")

func make_party_slot(pm, node):
	var slot = PartySlot.new()
	slot.pm = pm
	slot.node = node
	party_slots.append(slot)
