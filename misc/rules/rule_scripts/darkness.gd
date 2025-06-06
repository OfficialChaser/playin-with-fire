extends Rule

func set_rule_config(level : int = 1):
	GameManager.darkness_enabled = true
	GameManager.spread *= 2
	if level > 2:
		GameManager.darkness_radius /= 1.5

func reset_rule_config():
	GameManager.darkness_enabled = false
	GameManager.spread /= 2
