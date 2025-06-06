extends Rule

func set_rule_config(level : int = 1):
	GameManager.lightning_spawn_amt *= 2
	GameManager.day_duration = round(GameManager.day_duration / 2)
	if level > 2:
		GameManager.reroll_cost = 5

func reset_rule_config():
	GameManager.lightning_spawn_amt /= 2
	GameManager.day_duration = round(GameManager.day_duration * 2)
	GameManager.reroll_cost = 1
