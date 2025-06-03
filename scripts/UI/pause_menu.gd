extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('restart'):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("Pause"):
		if !get_tree().paused:
			show()
			get_tree().paused = true

func _unhandled_input(event: InputEvent) -> void:
	if get_tree().paused:
		if event.is_pressed() and not event.is_echo():
			get_tree().paused = false
			hide()
