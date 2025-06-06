extends Rule

func set_rule_config(level : int = 1):
	GameManager.hp_gain *= 2
	GameManager.player_damage *= 2
	if level > 2:
		GameManager.sellSoul = true

func reset_rule_config():
	GameManager.hp_gain = GameManager.start_hp_gain
	GameManager.player_damage = GameManager.start_player_damage

	GameManager.sellSoul = false
