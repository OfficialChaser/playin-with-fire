extends Rule

func set_rule_config(level : int = 1):
	GameManager.water_color = Color("703843")
	GameManager.blood_enabled = true
	if level == 2:
		GameManager.max_hp *= 2
		GameManager.player_health *= 2

func reset_rule_config():
	GameManager.water_color = Color.BLUE
	GameManager.blood_enabled = false
	GameManager.max_hp = GameManager.start_max_hp
	GameManager.player_health = GameManager.start_player_health
