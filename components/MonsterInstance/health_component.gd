class_name HealthComponent extends Resource

var max_hp : int
var current_hp : int

func setup_from_stats(stats: StatsComponent) -> void:
	max_hp = stats.base_hp
	current_hp = max_hp
	
func take_damage(amount: int) -> void:
	current_hp = max(current_hp - amount, 0)
	
func heal(amount: int) -> void:
	current_hp = min(current_hp + amount, max_hp)
	
func is_dead() -> bool:
	return current_hp <= 0
