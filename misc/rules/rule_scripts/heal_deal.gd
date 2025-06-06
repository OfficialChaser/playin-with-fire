extends Rule

func set_rule_config(level : int = 1):
	GameManager.hp_gain *= 2
	GameManager.fire_damage *= 2
	if level > 2:
		GameManager.regen_enabled = true
