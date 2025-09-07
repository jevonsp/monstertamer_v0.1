extends Node2D

@export var bar : TextureProgressBar

var monster: MonsterInstance

func assign_monster(m: MonsterInstance) -> void:
	if monster:
		if monster.is_connected("new_hp_value", Callable(self, "_new_hp_value")):
			monster.disconnect("new_hp_value", Callable(self, "_new_hp_value"))
	
	monster = m
	if not monster: return
	
	monster.connect("new_hp_value", Callable(self, "_new_hp_value"))
	
	bar.min_value = 0
	bar.max_value = (monster.hitpoints) * 100
	bar.value = (monster.current_hp) * 100

func _new_hp_value(new: int) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(bar, "value", float(new) * 100, .5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
