extends Rule


func set_rule_text(rule_menu : RuleMenu, level : int = 1):
	rule_menu.cool_label.text = ' '
	rule_menu.nerf_label.text = nerf_label
	rule_menu.buff_label.text = buff_label # two upgrades have this, maybe swap out ???
	if level > 1:
		rule_menu.cool_label.text = cool_label

func set_rule_config(level : int = 1):
	print('setting rule')
	GameManager.hose_knockback *= 2
	GameManager.player_damage *= 2
	if level > 1:
		pass

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
