extends Resource
class_name Rule

@export_category('Rule Attributes')
@export var rule_name : String
@export var cool_label : String
@export var nerf_label : String
@export var buff_label : String


func set_rule_text(rule_menu : RuleMenu, level : int = 1):
	rule_menu.cool_label.text = " "
	rule_menu.nerf_label.text = nerf_label
	rule_menu.buff_label.text = buff_label 
	if level > 1:
		rule_menu.cool_label.text = cool_label

func set_rule_config(_level : int = 1):
	pass

func reset_rule_config():
	pass
