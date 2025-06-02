extends Node

# Game vars
var in_game := true

# Player vars
var player_health := 100
var day := 1

func damage_player(damage: int):
	player_health -= damage
	
	if player_health <= 0:
		# game over sequence (placeholder for now)
		get_tree().reload_current_scene()
		player_health = 100
		pass

func day_completed(_way: String):
	player_health = 100
	in_game = false
	day += 1
	get_tree().reload_current_scene()
	in_game = true
