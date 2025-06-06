extends Rule

func set_rule_config(level : int = 1):
	GameManager.roll_tmrw = false
	GameManager.rerolls += 2
	if level > 2:
		GameManager.reroll_cost = 5
