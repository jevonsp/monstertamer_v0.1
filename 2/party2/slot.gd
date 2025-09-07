extends Node2D

func update(monster: MonsterInstance) -> void:
	if monster:
		$Background/ExpBar/Label.text = monster.species
		$Background/TextureRect.texture = monster.image
		$Background/HPBar.max_value = monster.hitpoints
		$Background/HPBar.value = monster.current_hp
		
