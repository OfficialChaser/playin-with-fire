extends Rule

func set_rule_config(level : int = 1):
	GameManager.hose_knockback *= 2
	GameManager.water_spawn_rate *= 2
	if level > 1:
		GameManager.fly_enabled = true

func reset_rule_config():
	print('resetting rule')
	GameManager.hose_knockback /= 2
	GameManager.player_damage /= 2

	#if rule == "double trouble":
		#if RuleManager.rule_levels[rule] == 2:
			#cool_label.text = "Fly"
		#nerf_label.text = "Double recoil"
		#buff_label.text = "Double damage"
#
