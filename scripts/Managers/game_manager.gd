extends Node

# Signals
signal rule_selected(rule : Rule)

# Preloads
const GameDefaults = preload("res://scripts/Managers/game_defaults.gd")
const TIME_CURVE = preload("res://misc/time_curve.tres")
var DIFFICULTY_CURVE = preload("res://misc/difficulty_curve.tres")

var stats := GameDefaults.START_STATS.duplicate(true)

# Game Loaded vars
var game_loaded := false

# UI / Options
var slider_speed := 1
var slider_sound_skip := 0.1

# Input Modes
enum InputMode { CONTROLLER, WASD, ARROWS, HJKL, MOUSE }

func _ready() -> void:
	connect("rule_selected", on_rule_selected)

func on_rule_selected(rule: Rule):
	if rule:
		stats["current_rule"] = rule
		rule.set_rule_config(RuleManager.rule_levels[rule])

func damage_player(damage: int):
	if stats["in_game"] and not stats["game_over"]:
		stats["player_health"] -= damage

		if stats["player_health"] <= 0:
			stats["player_health"] = 0
			end_game()

func day_completed(way: String = ""):
	update_game_stats()
	stats["in_game"] = false

	if way == "smokin' bonus":
		stats["rerolls"] += 2

	get_tree().reload_current_scene()
	await rule_selected

	if stats["shortened_day"]:
		stats["day_duration"] -= stats["day_duration"] * 0.3

	if stats["deal_enabled"]:
		if randi_range(0, 1) == 1:
			stats["player_health"] += 50
		elif stats["player_health"] < 55:
			stats["player_health"] = 5
		else:
			stats["player_health"] -= 50

	stats["in_game"] = true

func restart_game():
	reset_vars()

	Transition.play("fade_in")
	await get_tree().create_timer(1).timeout

	get_tree().reload_current_scene()
	Transition.play("fade_out")
	MusicManager.play_music("game_music")

func end_game():
	stats["game_over"] = true
	stats["in_game"] = false

func update_game_stats():
	var health = stats["player_health"] + stats["hp_gain"]
	stats["player_health"] = min(health, stats["max_hp"])

	stats["day"] += 1
	stats["fire_spawn_rate"] = clamp(get_spawn_rate(), 0.01, 10000)
	stats["day_duration"] = get_day_duration()
	stats["lightning_spawn_amt"] += 1

func get_spawn_rate() -> float:
	if DIFFICULTY_CURVE:
		var day_clamped = clamp(stats["day"] + 1, 0, DIFFICULTY_CURVE.max_domain)
		return DIFFICULTY_CURVE.sample(day_clamped)
	else:
		push_warning("Spawn rate curve not set! Using fallback.")
		return 0.5

func get_day_duration() -> float:
	if TIME_CURVE:
		var day_clamped = clamp(stats["day"] + 1, 0, TIME_CURVE.max_domain)
		return TIME_CURVE.sample(day_clamped)
	else:
		push_warning("Time curve not set! Using fallback.")
		return 30.0

func reset_vars():
	stats = GameDefaults.START_STATS.duplicate(true)
	RuleManager.reset_rule_levels()
