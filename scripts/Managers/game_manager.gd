extends Node

signal rule_selected

# Game vars
var in_game := true
var game_over := false

# Game stats
var player_health := 100
var day := 1
var fire_spawn_rate := 0.2
var rerolls := 3
# indicates what keys are on
var keys := [true, true, true, true] # keys order is left right up down

# Misc
var lightning_delay_time = 1.0

# Input
enum InputMode { CONTROLLER, WASD, ARROWS, HJKL, MOUSE } # we so we can show what key is removed in "remove key"
var look_mode = InputMode.MOUSE
var key_mode = InputMode.WASD

# keys - left right up down, to match the keys variable


# tiny change, look_mode is either MOUSE or CONTROLLER
# while key_mode is what movement keys the player moves with
# key_mode can be used to show that you remove "up key" as what they use to move up, so it looks better

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
	player_health = 100
	day = 1
	fire_spawn_rate = 0.2
	rerolls = 3
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
