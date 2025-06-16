extends Rule

var rng

func set_rule_text(rule_menu : RuleMenu, _level : int = 1):
	var keyboard = rule_menu.keyboard
	
	keyboard.visible = true
	# keys = [["A", "D", "W", "S"], ["←", "→", "↑", "↓"], ["H", "L", "K", "J"]] + controller keys
	
	var thing
	var choices = []
	for i in range(3):
		if !GameManager.used_keys.has(i):
			choices.append(i)
	rng = choices.pick_random()
	
	if GameManager.look_mode == GameManager.InputMode.CONTROLLER:
		keyboard.frame = 12 + rng
		thing = "stick"
	else:
		var km : int = InputManager.detect_key_layout()
		keyboard.frame = (km-1)*4 + rng
		thing = "key"

	rule_menu.cool_label.text = ' '
	rule_menu.nerf_label.text = nerf_label + thing
	rule_menu.buff_label.text = buff_label
	if _level > 1:
		rule_menu.cool_label = cool_label

func set_rule_config(level : int = 1):
	GameManager.used_keys.append(rng)
	GameManager.player_move_speed *= 1.5
	GameManager.keys[rng] = false
	if level > 2:
		if GameManager.hose_knockback > 0:
			GameManager.hose_knockback *= -1
	else:
		GameManager.hose_knockback *= 3

func reset_rule_config():
	for key in GameManager.keys:
		GameManager.keys[key] = true
	#GameManager.fly = false
