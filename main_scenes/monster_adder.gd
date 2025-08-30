extends Area2D

@export_subgroup("Nodes")
@export var party : Node
@export var monster_factory : Node

@export var monster_data : MonsterData
@export var level : int


func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	var event = EncounterEvent.new(monster_data, level)
	var instance = monster_factory.create_from_encounter(event)
	party.add_child(instance)
