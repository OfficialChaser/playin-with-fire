extends Node

# Signals
signal rule_selected(rule : Rule)

# Preloads
const TIME_CURVE = preload("res://misc/time_curve.tres")
const DIFFICULTY_CURVE = preload("res://misc/difficulty_curve.tres")

# Game States
var in_game := false
var game_over := false:
	set(_game_over):
		if _game_over:
			in_game = false
var actively_playing : bool:
	get:
		return in_game and not game_over

# UI / Options
var slider_speed := 1
var slider_sound_skip := 0.1

# Input Modes
enum InputMode { CONTROLLER, WASD, ARROWS, HJKL, MOUSE }

func _ready() -> void:
	connect("rule_selected", _on_rule_selected)

func day_completed(way: String = ""):
	update_game_stats()
	GameStats.in_game = false

	if way == "smokin' bonus":
		GameStats.rerolls += 2

	get_tree().reload_current_scene()
	await rule_selected

	if GameStats.shortened_day:
		GameStats.day_duration -= GameStats.day_duration * 0.3

	if GameStats.deal_enabled:
		if randi_range(0, 1) == 1:
			stats.player_health += 50
		elif stats.player_health < 55:
			stats.player_health = 5
		else:
			stats.player_health -= 50

	stats.in_game = true

func restart_game():
	reset_vars()

	Transition.play("fade_in")
	await get_tree().create_timer(1).timeout

	get_tree().reload_current_scene()
	Transition.play("fade_out")
	MusicManager.play_music("game_music")

func end_game():
	stats.game_over = true
	stats.in_game = false

func update_game_stats():
	var health = stats.player_health + stats.hp_gain
	stats.player_health = min(health, stats.max_hp)

	stats.day += 1
	stats.fire_spawn_rate = max(get_spawn_rate(), 0.01)
	stats.day_duration = get_day_duration()
	stats.lightning_spawn_amt += 1



func reset_vars():
	RuleManager.reset_rule_levels()

# Callback functions
func _on_rule_selected(rule: Rule):
	if rule:
		stats.current_rule = rule
		rule.set_rule_config(RuleManager.rule_levels[rule])
