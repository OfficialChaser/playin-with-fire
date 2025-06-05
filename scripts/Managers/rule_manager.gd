extends Node

var rule_paths : Array[String] = [
	"res://misc/rules/double_trouble.tres", 
	"res://misc/rules/bloody_stuff.tres",
	"res://misc/rules/cursor_trap.tres", 
	"res://misc/rules/darkness.tres", 
	"res://misc/rules/limited_water.tres", 
	"res://misc/rules/lose_a_key.tres",
	"res://misc/rules/save_the_trees.tres"
]

var rules : Array[Rule] 


#= ["double trouble", "lose a key", "cursor trap", "save the trees", "bloody stuff", "limited water", "DARKNESS"] # "stop the flood"
var used_rules := []


var rule_levels = {} # Resource rule : int level

var current_rule : Rule

func _ready():
	for path in rule_paths:
		var rule_resource = load(path)
		if rule_resource:
			rules.append(rule_resource)

	for rule in rules:
		rule_levels[rule] = 1	# "double trouble" : 1 , "lose a key" : 1, ...

func pick_random_rule() -> Rule:
	# Prevent rerolling the same rule
	var possible_rules = rules.duplicate()
	for used_rule in used_rules:
		if rules.has(used_rule):
			possible_rules.erase(used_rule)
			
	if !possible_rules:
		return current_rule
		
	current_rule = possible_rules[0] ###!!!! This is for Debug purposes !!!! Should be pick_random()
	used_rules.append(current_rule)
	
	return current_rule

func select_rule():
	rule_levels[current_rule] += 1
	used_rules.clear()
