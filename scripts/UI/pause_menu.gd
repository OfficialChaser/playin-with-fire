extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('restart'):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("pause"):
		if !get_tree().paused:
			show()
			get_tree().paused = true

func _unhandled_input(event: InputEvent) -> void:
	if get_tree().paused:
		if event.is_pressed() and not event.is_echo():
			get_tree().paused = false
			hide()


func _on_button_pressed() -> void:
	get_tree().quit()
