extends Control

var enabled := false
var confirm := false
var cool := true #cooldown but bool
# ↑ just here so you don't flip in and out when pause is "held"

func _ready():
	visible = false
	
	if GameStats.has_selected_first_rule:
		await GameManager.rule_selected
	await get_tree().create_timer(3).timeout
	enabled = true

func _process(_delta: float) -> void:
	if not GameManager.in_game:
		return
		
	if Input.is_action_just_pressed("pause"):
		if !get_tree().paused and enabled:
			show()
			get_tree().paused = true
			if GameManager.key_mode == GameManager.InputMode.CONTROLLER:
				$PausePanel/ResumeButton.grab_focus()
	handle_ctrler()
	
func handle_ctrler():
	var focus = get_viewport().gui_get_focus_owner()
	if Input.is_action_just_pressed("spray") and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if focus is Button:
			focus.emit_signal("pressed")

func unpause():
	get_tree().paused = false
	confirm = false
	hide()
	
func _on_resume_button_pressed():
	unpause()

func _on_exit_button_pressed() -> void:
	GameManager.end_game()
	GameManager.reset_vars()
	get_tree().paused = false
	MusicManager.play_music()
	enabled = false
	Transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
