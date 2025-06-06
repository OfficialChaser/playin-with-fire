extends Node

signal rule_selected(rule : Rule)

# Game vars
var in_game := true
var game_over := false
const DIFFICULTY_CURVE = preload("res://misc/difficulty_curve.tres")
var difficulty_curve: Curve
## Game Starting stats - These can be used to reset the game stats after a rule change or reload
var day := 1
const start_fire_spawn_rate := 0.08
const start_lightning_spawn_amt := 5
const start_rerolls := 3
const start_player_damage := 2

# Double Trouble
const start_hose_knockback := 50.0
const start_water_spawn_rate := 50.0
const start_fly := false

#heal deal
const start_fire_damage : int = 10

# gambling addict
const start_roll_tmrw = true

#lightning fast
const start_day_duration = 30

# Bloody Stuff
const start_player_health := 100
const start_water_color := Color("3f5886")
const start_player_blood_damage := 1
const start_blood_enabled := false
const start_max_hp := 100
const start_hp_gain := 50

# Darkness
const start_darkness_enabled := false
const start_darkness_radius := 120.0
const start_spread := 10

# Lose a key
const start_player_move_speed := 75.0

## Game stats - change these with the rules
var player_damage := start_player_damage

# Double Trouble
var hose_knockback := start_hose_knockback
var water_spawn_rate := start_water_spawn_rate
var fly_enabled := start_fly

# heal deal
var sellSoul := true
var fire_damage := start_fire_damage
# gambling addict
var roll_tmrw := start_roll_tmrw

# Lightning fast
var day_duration := start_day_duration

# Bloody Stuff
var player_health := start_player_health
var water_color := start_water_color
var player_blood_damage := start_player_blood_damage
var blood_enabled := start_blood_enabled
var max_hp := start_max_hp
var hp_gain := start_hp_gain

# Darkness
var darkness_enabled := start_darkness_enabled
var darkness_radius := start_darkness_radius
var spread := start_spread

# Lose a key
var used_keys := []
var player_move_speed := start_player_move_speed

# indicates what keys are on
var keys := [true, true, true, true] # keys order is left right up down

# Misc
var rerolls := start_rerolls
var fire_spawn_rate := start_fire_spawn_rate
var lightning_spawn_amt := start_lightning_spawn_amt
var lightning_delay_time = 0.6
var current_rule : Rule = null

# Input
enum InputMode { CONTROLLER, WASD, ARROWS, HJKL, MOUSE } # we so we can show what key is removed in "remove key"
var look_mode = InputMode.MOUSE
var key_mode = InputMode.WASD


# tiny change, look_mode is either MOUSE or CONTROLLER
# while key_mode is what movement keys the player moves with
# key_mode can be used to show that you remove "up key" as what they use to move up, so it looks better

func _ready() -> void:
	connect('rule_selected',on_rule_selected)


func on_rule_selected(rule : Rule):
	#if current_rule:
		#current_rule.reset_rule_config()
	if rule:
		current_rule = rule
		current_rule.set_rule_config(RuleManager.rule_levels[current_rule])


func damage_player(damage: int):
	if in_game and not game_over:
		player_health -= damage
	
		if player_health <= 0:
			player_health = 0
			end_game()

func day_completed(way: String = ""):
	update_game_stats()
	in_game = false
	
	if way == "smokin' bonus":
		GameManager.rerolls += 1
	
	# reload scene with updated stuff
	get_tree().reload_current_scene()
	await rule_selected
	in_game = true

func restart_game():
	# Reset stats
	reset_vars()
	
	keys = [true, true, true, true] # keys order is left right up down
	
	# Play transition
	Transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	
	# Reload scene and reset game vars
	get_tree().reload_current_scene()
	game_over = false
	in_game = true
	
	# Play animation
	Transition.play("fade_out")
	
	# Restart Music
	MusicManager.play_music("game_music")

func end_game():
	game_over = true
	in_game = false

func update_game_stats():
	if player_health + hp_gain > max_hp:
		player_health = max_hp
	else:
		player_health += hp_gain
	day += 1
	
	# figure out some sort of log or exp function here to get a better difficulty curve
	fire_spawn_rate = get_spawn_rate()
	lightning_spawn_amt += 1
	fire_spawn_rate = clamp(fire_spawn_rate, 0.01, 10000)
	
func get_spawn_rate() -> float:
	if DIFFICULTY_CURVE:
		var day_clamped = clamp(day+1, 0, DIFFICULTY_CURVE.max_domain)
		var difficulty : float = DIFFICULTY_CURVE.sample(day_clamped)
		print(difficulty)
		return difficulty
	else:
		push_warning("Spawn rate curve not set! Using fallback.")
		return 0.5

func reset_vars():
	day = 1
	fire_spawn_rate = start_fire_spawn_rate
	player_damage  = start_player_damage
	lightning_spawn_amt = start_lightning_spawn_amt
	rerolls = start_rerolls
	current_rule = null
	
	# Rule Manager
	RuleManager.maxed_rules.clear()
	
	# Heal deal
	sellSoul = false
	
	# gambling addictc
	roll_tmrw = start_roll_tmrw
	
	#lightning fast
	day_duration = start_day_duration
	
	# Double Trouble
	hose_knockback = start_hose_knockback
	water_spawn_rate = start_water_spawn_rate
	fly_enabled = start_fly

	# Bloody Stuff
	player_health = start_player_health
	water_color = start_water_color
	player_blood_damage = start_player_blood_damage
	blood_enabled = start_blood_enabled
	max_hp = start_max_hp
	hp_gain = start_hp_gain

	# Darkness
	darkness_enabled = start_darkness_enabled
	darkness_radius = start_darkness_radius
	spread = start_spread

	# Lose a key
	used_keys = []
	player_move_speed = start_player_move_speed
