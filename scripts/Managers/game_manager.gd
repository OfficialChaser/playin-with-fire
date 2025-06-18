extends Node

# Signals
signal rule_selected(rule : Rule)

# Game States
var game_loaded := false

var _in_game := false
var in_game: 
	set(value):
		_in_game = value
	get: 
		return _in_game

var _game_over := false
var game_over: 
	set(value):
		_game_over = value
		if value:
			in_game = false
	get:
		return _game_over

var actively_playing: 
	get:
		return in_game and not game_over


# Input Modes
enum InputMode { CONTROLLER, WASD, ARROWS, HJKL, MOUSE }

func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	connect("rule_selected", _on_rule_selected)

func day_completed(day_result: String = ""):
	in_game = false  # Already changed in GUI, but a good safeholder
	GameStats.process_day_end(day_result)
	
	get_tree().reload_current_scene()
	
	Transition.play("fade_out")
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
