extends Control
class_name GUI

@onready var day_timer = $DayTimer
@onready var day_label = $InfoPanel/VBoxContainer/DayLabel
@onready var hp_label = $InfoPanel/VBoxContainer/HPLabel
@onready var timer_label = $TimerPanel/TimerLabel

@onready var transition_animation_player = $Transition/AnimationPlayer
@onready var blur_animation_player = $ColorRect/AnimationPlayer



func _ready():
	blur_animation_player.play("RESET")
	transition_animation_player.play("fade_out")
	day_timer.start()

func _process(_delta):
	update_timer_label()
	update_health_label()
	update_day_label()

func update_timer_label():
	# Get the time left in seconds
	var time_left = day_timer.time_left
	# Calculate minutes and seconds
	var minutes = int(time_left / 60)
	var seconds = int(time_left) % 60
	# Format with leading zero for seconds
	timer_label.text = str(minutes) + ":" + str(seconds).pad_zeros(2)

func update_health_label():
	hp_label.text = "HP: " + str(GameManager.player_health)

func update_day_label():
	day_label.text = "Day " + str(GameManager.day)

func _on_day_timer_timeout():
	day_over_sequence()

func day_over_sequence(way: String = "time out"):
	GameManager.in_game = false
	day_timer.stop()
	await get_tree().create_timer(0.5).timeout
	blur_animation_player.play("blur_in")
	await get_tree().create_timer(2).timeout
	
	transition_animation_player.play("fade_in")
	
	await transition_animation_player.animation_finished
	GameManager.day_completed(way)
