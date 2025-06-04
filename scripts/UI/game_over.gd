extends Control

var started_anim := false
@onready var day_label = $ColorRect/VBoxContainer/DayLabel

func _ready():
	visible = false

func _process(_delta):
	if GameManager.game_over and not started_anim:
		visible = true
		started_anim = true
		
		# Placeholder
		await get_tree().create_timer(2).timeout
		day_label.text = "You survived until day " + str(GameManager.day)
		MusicManager.play_music()
		$AnimationPlayer.play("fade_in")

func _on_restart_button_pressed():
	GameManager.restart_game()
