extends Node

func _process(delta: float) -> void:
	if GameManager.regen_enabled: 
		GameManager.player_health += delta * GameManager.regen
		print_debug(delta * GameManager.regen)
		print_debug("regen test")	
