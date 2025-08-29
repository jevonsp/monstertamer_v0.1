class_name  MonsterFactory extends Node

# Convert PlayerMonster into Monster Instance
func create_from_player_data(pm: PlayerMonster) -> MonsterInstance:
	var monster = MonsterInstance.new()
	monster.set_monster_data(pm.base_data, pm.level)
	
	monster.stats_component = StatsComponent.new()
	monster.stats_component.base_hp = pm.current_hp
	
	monster.moves_component = MovesComponent.new()
	monster.known_moves = pm.moves.duplicate()

	monster.create_monster()
	return monster

# Convert Encounter Events into Monster Instance
func create_from_encounter(event: EncounterEvent) -> MonsterInstance:
	var monster = MonsterInstance.new()
	monster.set_monster_data(event.monster_data, event.level)
	
	monster.stats_component = StatsComponent.new()
	monster.stats_component.setup_monster_from_data(event)
	
	monster.health_component = HealthComponent.new()
	monster.health_component.setup_from_stats(monster.stats_component)
	
	monster.moves_component = MovesComponent.new()
	monster.moves_component.setup_moves_from_data(event.monster_data)
	monster.known_moves = monster.moves_component.moveset.duplicate()

	monster.create_monster()
	return monster
