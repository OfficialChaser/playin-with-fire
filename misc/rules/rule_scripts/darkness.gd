extends Rule

func set_rule_config(level : int = 1):
	GameStats.darkness_enabled = true
	GameStats.spread *= 2
	if level > 2:
		GameStats.darkness_radius /= 1.5
