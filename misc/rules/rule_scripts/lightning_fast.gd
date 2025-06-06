extends Rule

func set_rule_config(level : int = 1):
	GameManager.lightning_spawn_amt += int(GameManager.lightning_spawn_amt * 0.5)
	if level == 2:
		GameManager.day_duration = round(GameManager.day_duration / 1.3)
