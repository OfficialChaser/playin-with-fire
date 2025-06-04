extends Sprite2D
class_name FireDamageZone

@onready var fire_sfx = $FireSFX

func _ready():
	fire_sfx.pitch_scale = randf_range(0.8, 1.2)

func play_hit_flash():
	$ShaderAnimationPlayer.play("hit_flash")
