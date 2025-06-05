extends Rule

func set_rule_config(level : int = 1):
	GameManager.darkness_enabled = true
	GameManager.spread *=2
	if level > 1:
		GameManager.hose_knockback *= 0.5
