extends Node2D
@onready var pause_menu: Control = $CanvasLayer/PauseMenu

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('restart'):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("Pause"):
		if !get_tree().paused:
			pause_menu.show()
			get_tree().paused = true


#func _unhandled_input(event: InputEvent) -> void:
	# also called in hose.gd and game_over.gd and pause_menu.gd
	
#	if get_tree().paused:
#		if event.is_pressed() and not event.is_echo():
#			get_tree().paused = false
#			pause_menu.hide()
