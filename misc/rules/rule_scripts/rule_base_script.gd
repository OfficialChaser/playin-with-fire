extends Resource
class_name Rule

@export_category('Rule Attributes')
@export var rule_name : String
@export var cool_label : String
@export var nerf_label : String
@export var buff_label : String


func set_rule_text(rule_menu : RuleMenu, level : int = 1):
	rule_menu.cool_label.text = ' '
	rule_menu.nerf_label.text = nerf_label
	rule_menu.buff_label.text = buff_label # two upgrades have this, maybe swap out ???
	if level > 1:
		rule_menu.cool_label.text = cool_label

func set_rule_config(level : int = 1):
	pass

func reset_rule_config():
	pass
	#if rule == "double trouble":
		#if RuleManager.rule_levels[rule] == 2:
			#cool_label.text = "Fly"
		#nerf_label.text = "Double recoil"
		#buff_label.text = "Double damage"
#
	#elif rule == "lose a key":
		#keyboard.visible = true
		## keys = [["A", "D", "W", "S"], ["←", "→", "↑", "↓"], ["H", "L", "K", "J"]] + controller keys
		#var thing
		#if GameManager.look_mode == GameManager.InputMode.CONTROLLER:
			#keyboard.frame = 12 + randi_range(0, 3)
			#thing = "stick"r
		#else:
			#var km : int = KeyManager.keys_layout()
			#keyboard.frame = (km*4) - randi_range(1, 4) # (km-1)*4 + rng(0,3) 
			#thing = "key"
		#if RuleManager.rule_levels[rule] == 2:
			#cool_label.text = "Reverse recoil"
		#nerf_label.text = "Break the      " + thing
		#buff_label.text = "Double move speed"
	#elif rule == "cursor trap":
		#if RuleManager.rule_levels[rule] == 2:
			#cool_label.text = "Piercing water"
		#nerf_label.text = "The cursor is stuck"
		#buff_label.text = "Double spread" # two upgrades have this, maybe swap out ???
	#elif rule == "save the trees": # most abstract
		#if RuleManager.rule_levels[rule] == 2:
			#cool_label.text = "Plant trees"  # could be hard to add
		#nerf_label.text = "Burning trees steal HP"
		#buff_label.text = "Heal from watered trees"
	#elif rule == "bloody stuff":
		#if RuleManager.rule_levels[rule] == 2:
			#cool_label.text = "Blood pools" # might not be possible
		#nerf_label.text = "Shooting hurts"
		#buff_label.text = "Extra health"
	#elif rule == "limited water":
		#if RuleManager.rule_levels[rule] == 2:
			#cool_label.text = "Unlimited sprinklers"
		#nerf_label.text = "Ammo bar for water"
		#buff_label.text = "Sprinklers"
	#elif rule == "DARKNESS":
		#if RuleManager.rule_levels[rule] > 1:
			#cool_label.text = "Halved recoil"
		#nerf_label.text = "Vision is limited"
		#buff_label.text = "Double spread" # two upgrades have this, maybe swap out ???
