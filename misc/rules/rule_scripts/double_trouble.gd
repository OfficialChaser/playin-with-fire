extends Rule

func set_rule_config(_level : int = 1):
	if _level > 2:
		GameManager.hose_knockback *= 1.5
	GameManager.hose_knockback *= 2
	GameManager.water_spawn_rate *= 2

func reset_rule_config():
	pass
