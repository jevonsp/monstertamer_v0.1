class_name  MonsterFactory extends Node

# Convert Encounter Events into Monster Instance
func create_from_encounter(event: EncounterEvent) -> MonsterInstance:
	var monster = MonsterInstance.new()
	monster.set_monster_data(event.monster_data, event.level)
	
	monster.stats_component = StatsComponent.new()
	monster.stats_component.setup_monster_from_data(event)
	
	monster.health_component = HealthComponent.new()
	monster.health_component.setup_from_stats(monster.stats_component)
	
	monster.moves_component = MovesComponent.new()
	monster.moves_component.setup_moves_from_data(event.monster_data, event.level)
	monster.known_moves = monster.moves_component.moveset.duplicate()
	
	#monster.level_component = LevelingComponent.new()

	return monster
	
func create_from_pm(pm: PlayerMonster) -> MonsterInstance:
	print("asked for mi from pm")
	var monster = MonsterInstance.new()
	monster.set_monster_data(pm.base_data, pm.level)
	
	monster.stats_component = StatsComponent.new()
	monster.stats_component.level = pm.level
	monster.stats_component.base_hp = pm.base_data.base_hp
	monster.stats_component.base_attack = pm.base_data.base_attack
	monster.stats_component.base_defense = pm.base_data.base_defense
	monster.stats_component.base_speed = pm.base_data.base_speed
	monster.stats_component.base_dexterity = pm.base_data.base_dexterity
	
	monster.stats_component.current_attack = monster.stats_component.base_attack
	monster.stats_component.current_defense = monster.stats_component.base_defense
	monster.stats_component.current_speed = monster.stats_component.base_speed
	monster.stats_component.current_dexterity = monster.stats_component.base_dexterity
	
	monster.health_component = HealthComponent.new()
	monster.health_component.max_hp = monster.stats_component.base_hp
	monster.health_component.current_hp = pm.current_hp
	
	monster.moves_component = MovesComponent.new()
	monster.known_moves = pm.moves.duplicate()
	
	return monster
