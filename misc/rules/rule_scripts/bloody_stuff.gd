extends Rule

func set_rule_config(level : int = 1):
	GameManager.water_color = Color("703843")
	GameManager.blood_enabled = true
	if level == 2:
		GameManager.hp_max *= 2
		GameManager.player_health *= 2
