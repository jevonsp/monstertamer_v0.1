class_name HealthComponent extends Resource

signal hp_changed(new_hp)

var max_hp : int = 0
var current_hp : int = 0

func setup_from_stats(stats: StatsComponent) -> void:
	max_hp = stats.base_hp
	current_hp = max_hp
	
func take_damage(amount: int) -> void:
	current_hp = max(current_hp - amount, 0)
	hp_changed.emit(current_hp)
	
func heal(amount: int) -> void:
	current_hp = min(current_hp + amount, max_hp)
	
func is_dead() -> bool:
	return current_hp <= 0
