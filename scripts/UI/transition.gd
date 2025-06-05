extends CanvasLayer

signal animation_finished

func play(anim: String):
	$sweep/AnimationPlayer.play(anim)
	print("test")

func _on_animation_player_animation_finished(_anim_name):
	animation_finished.emit()
