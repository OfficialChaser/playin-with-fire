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

# Misc
var lightning_delay_time = 1.0

# Input
enum InputMode { CONTROLLER, MOUSE }
var input_mode = InputMode.MOUSE

func damage_player(damage: int):
	if in_game and not game_over:
		player_health -= damage
	
		if player_health <= 0:
			end_game()

func day_completed():
	update_game_stats()
	in_game = false
	
	# placeholder maybe
	await get_tree().create_timer(1).timeout
	
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
	fire_spawn_rate -= 0.02
	fire_spawn_rate = clamp(fire_spawn_rate, 0.01, 10000)
