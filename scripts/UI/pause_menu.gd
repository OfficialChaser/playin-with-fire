extends Control

var enabled := false

func _ready():
	await get_tree().create_timer(5).timeout
	enabled = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and enabled and GameManager.in_game:
		if !get_tree().paused:
			show()
			get_tree().paused = true

func _unhandled_input(event: InputEvent) -> void:
	if get_tree().paused:
		if event.is_pressed() and not event.is_echo() and not event.is_action("pause"):
			get_tree().paused = false
			hide()


func _on_button_pressed() -> void:
	get_tree().quit()
