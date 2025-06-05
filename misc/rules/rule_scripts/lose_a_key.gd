extends Rule

func set_rule_text(rule_menu : RuleMenu, level : int = 1):
	var keyboard = rule_menu.keyboard
	
	keyboard.visible = true
	# keys = [["A", "D", "W", "S"], ["←", "→", "↑", "↓"], ["H", "L", "K", "J"]] + controller keys
	var thing
	if GameManager.look_mode == GameManager.InputMode.CONTROLLER:
		keyboard.frame = 12 + randi_range(0, 3)
		thing = "stick"
	else:
		var km : int = KeyManager.keys_layout()
		keyboard.frame = (km*4) - randi_range(1, 4) # (km-1)*4 + rng(0,3) 
		thing = "key"

	rule_menu.cool_label.text = ' '
	rule_menu.nerf_label.text = nerf_label + thing
	rule_menu.buff_label.text = buff_label 
	if level > 1:
		rule_menu.cool_label.text = cool_label
