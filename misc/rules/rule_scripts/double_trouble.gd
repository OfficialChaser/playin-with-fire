extends Rule

func set_rule_config(level : int = 1):
	GameManager.hose_knockback *= 2
	GameManager.water_spawn_rate *= 2
	if level > 2:
		GameManager.fly_enabled = true

func reset_rule_config():
	pass
