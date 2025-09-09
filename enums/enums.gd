class_name E

enum Type {NONE, FIRE, WATER, GRASS, LIGHT, DARK}
enum Role {NONE, MELEE, RANGE, TANK, MAGE, CLERIC, BARD}
enum GrowthRate {SLOWEST, SLOW, MEDIUM, FAST, FASTEST}
enum Gender {MALE = 1, FEMALE = 2, NONE = 4}

static var type_chart : Dictionary = {
	Type.NONE: {Type.NONE: 1.0, Type.FIRE: 1.0, Type.WATER: 1.0, Type.GRASS: 1.0, Type.LIGHT: 1.0, Type.DARK: 1.0},
	Type.FIRE: {Type.NONE: 1.0, Type.FIRE: 1.0, Type.WATER: 0.75, Type.GRASS: 1.25, Type.LIGHT: 1.0, Type.DARK: 1.0},
	Type.WATER: {Type.NONE: 1.0, Type.FIRE: 1.25, Type.WATER: 1.0, Type.GRASS: 0.75, Type.LIGHT: 1.0, Type.DARK: 1.0},
	Type.GRASS: {Type.NONE: 1.0, Type.FIRE: 0.75, Type.WATER: 1.25, Type.GRASS: 0.75, Type.LIGHT: 1.0, Type.DARK: 1.0},
	Type.LIGHT: {Type.NONE: 1.0, Type.FIRE: 1.0, Type.WATER: 1.0, Type.GRASS: 1.0, Type.LIGHT: 0.5, Type.DARK: 1.5},
	Type.DARK: {Type.NONE: 1.0, Type.FIRE: 1.0, Type.WATER: 1.0, Type.GRASS: 1.0, Type.LIGHT: 1.5, Type.DARK: 0.5}}

static func get_type_multi(attacker_type: int, defender_type: int) -> float:
	var defender_chart = type_chart.get(attacker_type, {})
	return defender_chart.get(defender_type, 1.0)
