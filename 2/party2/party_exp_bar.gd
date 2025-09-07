extends Node2D

@export var bar : TextureProgressBar
@export var label : Label

var monster: MonsterInstance

func assign_monster(m: MonsterInstance) -> void:
	if monster:
		if monster.is_connected("exp_gained", Callable(self, "_on_exp_gained")):
			monster.disconnect("exp_gained", Callable(self, "_on_exp_gained"))
		if monster.is_connected("lvl_gained", Callable(self, "_on_lvl_gained")):
			monster.disconnect("lvl_gained", Callable(self, "_on_lvl_gained"))
	
	monster = m
	if not monster: return
	
	monster.connect("exp_gained", Callable(self, "_on_exp_gained"))
	monster.connect("lvl_gained", Callable(self, "_on_lvl_gained"))
	
	update_bar_immediate(monster.exp_percent)
	update_lvl_immediate()
	
func update_bar_immediate(percent):
	bar.value = percent
	
func update_lvl_immediate():
	label.text = "Lvl. %d" % monster.level

func _on_exp_gained(percent: float) -> void:
	print("got signal, percent: %f" % percent)
	update_bar_immediate(percent)
	
func _on_lvl_gained() -> void:
	print("got lvl gained signal")
	update_lvl_immediate()
