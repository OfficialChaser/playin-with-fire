extends Rule

func set_rule_config(level : int = 1):
	GameManager.roll_tmrw = false
	GameManager.rerolls += 2
	if level > 2:
		GameManager.player_health += randi_range(-50, 50)
		#GameManager.reroll_cost = 5

func reset_rule_config():
	GameManager.roll_tmrw = true
	#GameManager.reroll_cost = 1
