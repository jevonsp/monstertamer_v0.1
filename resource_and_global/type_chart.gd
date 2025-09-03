class_name TypeChart

enum Type { FIRE, WATER, GRASS, NONE }

static var chart = {
	MonsterData.Type.FIRE: {Type.FIRE: 1.0, Type.WATER: 0.5, Type.GRASS: 2.0},
	MonsterData.Type.WATER: {Type.FIRE: 2.0, Type.WATER: 1.0, Type.GRASS: 0.5},
	MonsterData.Type.GRASS: {Type.FIRE: 0.5, Type.WATER: 2.0, Type.GRASS: 1},
	MonsterData.Type.NONE: {Type.FIRE: 1.0, Type.WATER: 1.0, Type.GRASS: 1}
	}

static func get_multi(attacking, defending):
	if chart.has(attacking) and chart[attacking].has(defending):
		return chart[attacking][defending]
	return 1.0
