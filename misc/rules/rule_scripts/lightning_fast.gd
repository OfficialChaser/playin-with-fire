extends Rule

func set_rule_config(_level : int = 1):
	GameStats.lightning_spawn_amt += int(GameStats.lightning_spawn_amt * 0.5)
	GameStats.shortened_day = true
