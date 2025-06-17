extends Rule

func set_rule_config(level : int = 1):
	GameStats.roll_tmrw = false
	GameStats.rerolls += 2
	if level > 2:
		GameStats.deal_enabled = true

func reset_rule_config():
	GameStats.roll_tmrw = true
