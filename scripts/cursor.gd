extends Sprite2D
class_name Cursor

func _ready():
	visible = InputManager.using_kbm
	global_position = get_global_mouse_position()
	InputManager.connect("changed_input_method", _on_input_method_changed)
	

func _input(event):
	if event is InputEventMouseMotion:
		global_position = get_global_mouse_position()

func _on_input_method_changed(new_method):
	visible = new_method != InputManager.InputMode.CONTROLLER
