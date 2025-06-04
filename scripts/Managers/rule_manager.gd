extends Node

var rules := ["double trouble", "lose a key", "cursor trap", "save the trees", "bloody stuff", "limited water", "DARKNESS"] # "stop the flood"
var used_rules := []


var rule_levels = {} # Rule rule : int level

var current_rule : String

func _ready():
	for rule in rules:
		rule_levels[rule] = 1	# "double trouble" : 1 , "lose a key" : 1, ...

func pick_random_rule() -> String:
	# Prevent rerolling the same rule
	var possible_rules = rules.duplicate()
	for used_rule in used_rules:
		if rules.has(used_rule):
			possible_rules.erase(used_rule)
			
	if !possible_rules:
		return current_rule
		
	current_rule = possible_rules.pick_random()
	used_rules.append(current_rule)
	
	return current_rule

func clear_used_rules():
	used_rules.clear()

func picked_rule(rule):
	rule_levels[rule] += 1
