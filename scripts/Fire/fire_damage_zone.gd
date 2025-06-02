extends Sprite2D
class_name FireDamageZone

func play_hit_flash():
	$ShaderAnimationPlayer.play("hit_flash")
