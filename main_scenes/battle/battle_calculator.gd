extends Node

signal damage_calculated(user, target, damage)

func calc_damage(user, target, move):
	var base_damage = user.get_effective_attack(move)
	var type_multi = TypeChart.get_multi(move.type, target.monster_data.type)
	var final_dmg = int((base_damage - (target.stats_component.current_defense / 4)) * type_multi)
	damage_calculated.emit(user, target, final_dmg)
	return final_dmg
