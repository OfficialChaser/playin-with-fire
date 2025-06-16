extends Node

# Signals
signal rule_selected(rule : Rule)

# Game States
var game_loaded := false
var in_game := false
var game_over := false:
	set(_game_over):
		if _game_over:
			in_game = false
var actively_playing : bool:
	get:
		return in_game and not game_over

# Input Modes
enum InputMode { CONTROLLER, WASD, ARROWS, HJKL, MOUSE }

func _ready():
	connect("rule_selected", _on_rule_selected)

func day_completed(day_result: String = ""):
	in_game = false
	GameStats.process_day_end(day_result)
	
	get_tree().reload_current_scene()
	
	await rule_selected
	
	in_game = true

func restart_game():
	# Make a way to reset all stats
	RuleManager.reset_rule_levels()

	Transition.play("fade_in")
	await get_tree().create_timer(1).timeout

	get_tree().reload_current_scene()
	Transition.play("fade_out")
	MusicManager.play_music("game_music")

func end_game():
	game_over = true

# Callback functions
func _on_rule_selected(rule: Rule):
	if rule:
		GameStats.current_rule = rule
		rule.set_rule_config(RuleManager.rule_levels[rule])
