extends Node

signal rule_selected(rule : Rule)

# Game vars
var in_game := true
var game_over := false

# Game Starting stats - These can be used to reset the game stats after a rule change or reload
var day := 1
const start_fire_spawn_rate := 0.2
const start_rerolls := 10

const start_hose_knockback := 50
const start_player_damage := 2

const start_player_health := 100
const start_water_spawn_rate := 50.0
const start_water_color := Color("3f5886")
const start_player_blood_damage := 1

# Game stats - change these with the rules
var player_health := start_player_health
var fire_spawn_rate := start_fire_spawn_rate
var rerolls := start_rerolls
var hose_knockback := start_hose_knockback
var player_damage := start_player_damage
var water_spawn_rate := start_water_spawn_rate
var water_color := start_water_color
var player_blood_damage := start_player_blood_damage


# indicates what keys are on
var keys := [true, true, true, true] # keys order is left right up down

# Misc
var lightning_delay_time = 1.0
var current_rule : Rule = null

# Input
enum InputMode { CONTROLLER, WASD, ARROWS, HJKL, MOUSE } # we so we can show what key is removed in "remove key"
var look_mode = InputMode.MOUSE
var key_mode = InputMode.WASD

# keys - left right up down, to match the keys variable


# tiny change, look_mode is either MOUSE or CONTROLLER
# while key_mode is what movement keys the player moves with
# key_mode can be used to show that you remove "up key" as what they use to move up, so it looks better

func _ready() -> void:
	connect('rule_selected',on_rule_selected)


func on_rule_selected(rule : Rule):
	if current_rule:
		current_rule.reset_rule_config()
	current_rule = rule
	current_rule.set_rule_config(RuleManager.rule_levels[current_rule])


func damage_player(damage: int):
	if in_game and not game_over:
		player_health -= damage
	
		if player_health <= 0:
			end_game()

func day_completed(way: String = ""):
	update_game_stats()
	in_game = false
	
	if way == "smokin' bonus":
		GameManager.rerolls += 1
	
	# placeholder maybe
	await get_tree().create_timer(0.1).timeout
	
	# reload scene with updated stuff
	get_tree().reload_current_scene()
	await rule_selected
	in_game = true

func restart_game():
	# Reset stats
	day = 1
	player_health = start_player_health
	fire_spawn_rate = start_fire_spawn_rate
	hose_knockback = start_hose_knockback
	player_damage  = start_player_damage

	rerolls = start_rerolls
	keys = [true, true, true, true] # keys order is left right up down

	
	# Play transition
	Transition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	
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
	player_health = 100
	day += 1
	
	# figure out some sort of log or exp function here to get a better difficulty curve
	fire_spawn_rate -= 0.02  # looks like fire spawn timer
	fire_spawn_rate = clamp(fire_spawn_rate, 0.01, 10000)
