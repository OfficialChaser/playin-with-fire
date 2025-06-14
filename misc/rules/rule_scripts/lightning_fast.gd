extends Rule

func set_rule_config(_level : int = 1):
	GameManager.lightning_spawn_amt += int(GameManager.lightning_spawn_amt * 0.5)
	GameManager.shortened_day = true
