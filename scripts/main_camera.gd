extends Camera2D
class_name MainCamera

var shaking := false

@export_range(0, 0.2) var offset_factor : float

var initial_offset = offset

var random_strength : float
var shake_fade : float

var rng = RandomNumberGenerator.new()

var shake_strength := 0.0

# References
@onready var animation_player = $AnimationPlayer


func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0.0, shake_fade * delta)
		offset = random_offset() + initial_offset


func apply_shake(strength: float, fade : float):
	shake_strength = strength
	shake_fade = fade

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func play_red_tint_anim():
	animation_player.play("hurt")

func zoom_in_on_house():
	#Disable GUI
	get_tree().current_scene.get_node("CanvasLayer").get_node("GUI").visible = false
	
	var tween = create_tween()
	tween.parallel().tween_property(
		self, "global_position", 
		Vector2(0, 0), 0.1
	)
	tween.parallel().tween_property(
		self, "zoom", 
		Vector2(9, 9), 0.6
	)
