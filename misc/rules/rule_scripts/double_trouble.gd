extends Rule

func set_rule_config(_level : int = 1):
	if _level > 2:
		GameStats.hose_knockback *= 1.5
	GameStats.hose_knockback *= 2
	GameStats.water_spawn_rate *= 2
