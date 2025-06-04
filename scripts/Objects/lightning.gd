extends AnimatedSprite2D

var spawn_timer : float = randf_range(0.5,1.5)

func _ready() -> void:
	await get_tree().create_timer(spawn_timer).timeout
	show()
	play("default")
	$LightningSFX.play()
	await animation_finished
	queue_free()
