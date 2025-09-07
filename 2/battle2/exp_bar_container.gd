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
	
	update_bar_immediate()
	update_lvl_immediate()
	
func update_bar_immediate():
	bar.value = monster.get_exp_percent()
	
func update_lvl_immediate():
	label.text = "Lvl. %d" % monster.level

func _on_exp_gained(percent: float) -> void:
	print("got signal, percect: %f" % percent)
	update_bar_immediate()
	
func _on_lvl_gained(level: int) -> void:
	update_lvl_immediate()
