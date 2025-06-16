extends Node2D

func _ready():
	Transition.play("fade_out")
	if GameStats.has_selected_first_rule:
		await GameManager.rule_selected
	GameManager.in_game = true
