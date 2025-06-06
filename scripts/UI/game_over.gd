extends Control

var started_anim := false
var faded := false
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
		faded = true
		# hide house on tilemap
		$"../../MidgroundTiles".set_cell(Vector2i(0, -1), -1)
		
func _unhandled_input(_event: InputEvent):
	if GameManager.game_over and faded:
		if Input.is_action_just_pressed("spray") or Input.is_action_just_pressed("restart") or Input.is_action_just_pressed("pause"):
				GameManager.restart_game()

func _on_restart_button_pressed():
	GameManager.restart_game()
