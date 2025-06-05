extends Rule

func set_rule_config(level : int = 1):
	GameManager.water_color = Color("703843")
	GameManager.player_health *= 2
	if level > 1:
		pass
