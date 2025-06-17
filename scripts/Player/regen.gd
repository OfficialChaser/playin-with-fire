extends Node

func _process(delta: float) -> void:
	if GameStats.regen_enabled and GameManager.in_game:
		GameStats.player_health += delta * GameStats.regen
