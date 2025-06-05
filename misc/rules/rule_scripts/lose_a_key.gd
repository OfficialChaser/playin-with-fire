extends Rule

func set_rule_text(rule_menu : RuleMenu, level : int = 1):
	var keyboard = rule_menu.keyboard
	
	keyboard.visible = true
	# keys = [["A", "D", "W", "S"], ["←", "→", "↑", "↓"], ["H", "L", "K", "J"]] + controller keys
	var thing
	var rng = randi_range(0, 3)
	if GameManager.look_mode == GameManager.InputMode.CONTROLLER:
		keyboard.frame = 12 + rng
		thing = "stick"
	else:
		var km : int = KeyManager.keys_layout()
		keyboard.frame = (km-1)*4 + rng
		thing = "key"
	GameManager.keys[rng] = false

	rule_menu.cool_label.text = ' '
	rule_menu.nerf_label.text = nerf_label + thing
	rule_menu.buff_label.text = buff_label 
	if level > 1:
		if GameManager.hose_knockback > 0:
			GameManager.hose_knockback *= -1
		rule_menu.cool_label.text = cool_label
