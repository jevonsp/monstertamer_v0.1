class_name LevelingComponent extends Resource

var stats_component : StatsComponent
var health_component : HealthComponent

func level_up():
	stats_component.level += 1
	stats_component.base_hp += 5
	stats_component.base_speed += 1
	stats_component.base_attack += 1
	stats_component.base_defense += 1
	stats_component.base_dexterity += 1
	health_component.max_hp = stats_component.base_hp
	health_component.current_hp = health_component.max_hp
