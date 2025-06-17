extends Sprite2D

var keypos = Vector2(76, 105)
var stickpos = Vector2(105, 100)

	
func _process(_delta):
	if InputManager.look_mode == InputManager.InputMode.CONTROLLER:
		self.position = stickpos
	else:
		self.position = keypos
