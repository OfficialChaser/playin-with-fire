extends Rule

func set_rule_config(level : int = 1):
	GameManager.hp_gain *= 2
	GameManager.player_damage *= 2
	if level > 2:
		GameManager.level2 = true
