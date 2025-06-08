extends Node

var rule_paths : Array[String] = [
	"res://misc/rules/double_trouble.tres", 
	"res://misc/rules/bloody_stuff.tres",
	"res://misc/rules/darkness.tres", 
	"res://misc/rules/lose_a_key.tres",
	"res://misc/rules/gambling_addict.tres",
	"res://misc/rules/heal_deal.tres",
	"res://misc/rules/lightning_fast.tres",
]

var rules : Array[Rule] 


#= ["double trouble", "lose a key", "save the trees", "bloody stuff", "limited water", "DARKNESS"] # "stop the flood"
var used_rules := []
var maxed_rules := []

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
	for maxed_rule in maxed_rules:
		if rules.has(maxed_rule):
			possible_rules.erase(maxed_rule)
			
	if !possible_rules:
		return current_rule
	possible_rules.shuffle()
	current_rule = possible_rules.pick_random()
	used_rules.append(current_rule)
	
	return current_rule

func select_rule():
	rule_levels[current_rule] += 1
	if rule_levels[current_rule] >= 4:
		maxed_rules.append(current_rule)
	used_rules.clear()
	
	

func player_has_maxed_out():
	var sorted_rules = rules.duplicate()
	var sorted_maxed = maxed_rules.duplicate()
	sorted_rules.sort()
	sorted_maxed.sort()

	return sorted_rules.size() == sorted_maxed.size()

func reset_rule_levels():
	for rule in rules:
		rule_levels[rule] = 1
	used_rules.clear()
	maxed_rules.clear()
