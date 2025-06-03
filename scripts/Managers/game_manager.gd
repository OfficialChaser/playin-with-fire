extends Node

# Game vars
var in_game := true
var game_over := false

# Game stats
var player_health := 100
var day := 1
var fire_spawn_rate := 0.2

func damage_player(damage: int):
	if in_game and not game_over:
		player_health -= damage
	
		if player_health <= 0:
			end_game()

func day_completed():
	update_game_stats()
	in_game = false
	
	# placeholder maybe
	await get_tree().create_timer(2).timeout
	
	# reload scene with updated stuff
	get_tree().reload_current_scene()
	in_game = true

func restart_game():
	player_health = 100
	day = 1
	fire_spawn_rate = 0.2
	game_over = false
	in_game = true
	
	Transition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()
	Transition.play("fade_out")

func end_game():
	game_over = true
	in_game = false

func update_game_stats():
	player_health = 100
	day += 1
	
	# figure out some sort of log or exp function here to get a better difficulty curve
	fire_spawn_rate -= 0.02
	fire_spawn_rate = clamp(fire_spawn_rate, 0.01, 10000)
