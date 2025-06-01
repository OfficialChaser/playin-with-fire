extends Node

# Player vars
var player_health := 100

func damage_player(damage: int):
	player_health -= damage
	
	if player_health <= 0:
		# game over sequence (placeholder for now)
		get_tree().reload_current_scene()
		player_health = 100
		pass
