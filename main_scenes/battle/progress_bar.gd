extends ProgressBar

func bind_to_monster(monster : MonsterInstance):
	max_value = monster.health_component.max_hp
	value = monster.health_component.current_hp
	monster.health_component.connect("hp_changed", Callable(self, "_on_hp_changed"))
	
func _on_hp_changed(new_hp: int) -> void:
	value = new_hp
