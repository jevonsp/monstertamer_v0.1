class_name LevelingComponent extends Resource

var stats_component : StatsComponent
var health_component : HealthComponent
var experience : int

func level_up(level):
	stats_component.level += level
	stats_component.current_speed = floor(stats_component.base_speed * stats_component.level)
	stats_component.current_attack = floor(stats_component.base_attack * stats_component.level)
	stats_component.current_defense = floor(stats_component.base_defense * stats_component.level)
	stats_component.current_dexterity = floor(stats_component.base_dexterity * stats_component.level)
	health_component.max_hp = floor(stats_component.base_hp * stats_component.level)
	health_component.current_hp += floor(stats_component.base_hp * stats_component.level)

func apply_level(level):
	stats_component.level = level
	stats_component.current_speed = floor(stats_component.base_speed * stats_component.level)
	stats_component.current_attack = floor(stats_component.base_attack * stats_component.level)
	stats_component.current_defense = floor(stats_component.base_defense * stats_component.level)
	stats_component.current_dexterity = floor(stats_component.base_dexterity * stats_component.level)
	health_component.max_hp = floor(stats_component.base_hp * stats_component.level)
