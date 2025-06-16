extends Control
class_name GUI

@onready var day_timer = $DayTimer
@onready var day_label = $InfoPanel/VBoxContainer/DayLabel
@onready var hp_label = $InfoPanel/VBoxContainer/HPLabel
@onready var timer_label = $TimerPanel/TimerLabel

@onready var blur_animation_player = $ColorRect/AnimationPlayer
@onready var day_success_animation_player = $DaySuccess/AnimationPlayer

@onready var rule_name: Label = $RuleInfo/RuleName

@onready var smokin_win_sfx = $SmokinWinSFX
@onready var reg_win_sfx = $RegWinSFX


func _ready():
	update_timer_label(true)
	blur_animation_player.play("RESET")
	Transition.play("fade_out")
	if GameStats.has_selected_first_rule:
		await GameManager.rule_selected
		day_timer.wait_time = GameStats.day_duration
	day_timer.wait_time = GameStats.day_duration
	day_timer.start()

func _process(_delta):
	update_timer_label()
	update_health_label()
	update_day_label()
	update_rule_label()
	

func update_timer_label(override: bool = false):
	if not GameManager.in_game and not override:
		return
	# Get the time left in seconds
	var time_left = day_timer.time_left
	# Calculate minutes and seconds
	var minutes = int(time_left / 60)
	var seconds = int(time_left) % 60
	# Format with leading zero for seconds
	timer_label.text = str(minutes) + ":" + str(seconds).pad_zeros(2)

func update_health_label():
	hp_label.text = "HP: " + str(GameStats.player_health)

func update_day_label():
	day_label.text = "Day " + str(GameStats.day)

func update_rule_label():
	if GameManager.current_rule:
		rule_name.text = GameStats.current_rule.rule_name
	else:
		rule_name.text = ''

func set_timer(f : float):
	day_timer.wait_time = f

func _on_day_timer_timeout():
	if GameManager.in_game and !GameManager.game_over:
		day_over_sequence()

func day_over_sequence(day_result: String = "time out"):
	GameManager.in_game = false
	day_timer.stop()
	await get_tree().create_timer(0.5).timeout
	blur_animation_player.play("blur_in")
	day_success_animation_player.play(day_result)
	
	if day_result == "time out":
		reg_win_sfx.play()
	elif day_result == "smokin' bonus":
		smokin_win_sfx.play()
	
	
	await get_tree().create_timer(5).timeout
	day_success_animation_player.play("RESET") # Could replace with a fade anim
	Transition.play("fade_in")
	
	await Transition.animation_finished
	GameManager.day_completed(day_result)

# Callback Functions
