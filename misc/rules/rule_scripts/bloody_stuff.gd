extends Rule

func set_rule_config(level : int = 1):
	GameStats.water_color = Color("703843")
	GameStats.blood_enabled = true
	GameStats.max_hp += 100
	GameStats.player_health *= 2
	if level > 2:
		#GameStats.player_blood_damage += 1
		GameStats.bloodHalf = true

func reset_rule_config():
	GameStats.water_color = Color.BLUE
	GameStats.blood_enabled = false
	GameStats.max_hp = GameStats.start_max_hp
	GameStats.player_health = GameStats.start_player_health
