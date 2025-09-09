extends Node2D

signal tween_finished

@export var bar : TextureProgressBar
@export var label : Label

var monster : MonsterInstance
var label_level : int

func assign_monster(m: MonsterInstance) -> void:
	if monster:
		if monster.is_connected("bat_exp_gained", Callable(self, "_on_bat_exp_gained")):
			monster.disconnect("bat_exp_gained", Callable(self, "_on_bat_exp_gained"))
	
	monster = m
	if !monster: return
	
	monster.connect("bat_exp_gained", Callable(self, "_on_bat_exp_gained"))
	
	update_bar_immediate(monster.exp_percent)
	update_lvl_immediate(monster.level)
	
func update_bar_immediate(percent: float):
	bar.value = percent
func update_lvl_immediate(level: int):
	label.text = "Lvl. %d" % level
	label_level = level
func _on_bat_exp_gained(new_exp: float, times_to_tween: int):
	while times_to_tween > 0:
		times_to_tween -= 1
		var tween = get_tree().create_tween()
		tween.tween_property(bar, "value", 100, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		await tween.finished
		tween_finished.emit()
		bar.value = 0
		await get_tree().create_timer(0.2).timeout
	tween_bar_percent(new_exp)

func _on_tween_finished() -> void:
	update_label()

func tween_bar_percent(percent: float):
	var tween = get_tree().create_tween()
	tween.tween_property(bar, "value", percent, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
func update_label() -> void:
	label_level += 1
	label.text = "Lvl. %d" % label_level
