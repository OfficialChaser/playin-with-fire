extends AnimatedSprite2D

var spawn_timer : float = randf()*3
func _ready() -> void:
	hide()
	await get_tree().create_timer(spawn_timer).timeout
	show()
	play("default")
	
	await animation_finished
	queue_free()
