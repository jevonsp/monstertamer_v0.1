class_name  MonsterFactory extends Node

# Convert Encounter Events into Monster Instance
func create_from_encounter(event: EncounterEvent) -> MonsterInstance:
	var monster = MonsterInstance.new()
	monster.set_monster_data(event.monster_data, event.level)
	
	monster.stats_component = StatsComponent.new()
	monster.stats_component.setup_monster_from_data(event)
	
	monster.health_component = HealthComponent.new()
	monster.health_component.setup_from_stats(monster.stats_component)
	
	monster.level_component = LevelingComponent.new()
	monster.level_component.stats_component = monster.stats_component
	monster.level_component.health_component = monster.health_component
	monster.level_component.apply_level(monster.current_level)
	monster.current_level = monster.stats_component.level
	monster.health_component.current_hp = monster.health_component.max_hp
	
	monster.moves_component = MovesComponent.new()
	monster.moves_component.setup_moves_from_data(event.monster_data, event.level)
	monster.known_moves = monster.moves_component.moveset.duplicate()
	
	return monster
	
func create_from_pm(pm: PlayerMonster) -> MonsterInstance:
	print("asked for mi from pm")
	var monster = MonsterInstance.new()
	monster.set_monster_data(pm.base_data, pm.level)
	
	monster.stats_component = StatsComponent.new()
	monster.stats_component.setup_monster_from_pm(pm)
	
	monster.health_component = HealthComponent.new()
	monster.health_component.setup_from_stats(monster.stats_component)
	
	monster.level_component = LevelingComponent.new()
	monster.level_component.stats_component = monster.stats_component
	monster.level_component.health_component = monster.health_component
	monster.level_component.apply_level(pm.level)
	monster.health_component.current_hp = pm.current_hp
	
	monster.moves_component = MovesComponent.new()
	monster.known_moves = pm.moves.duplicate()
	
	return monster
