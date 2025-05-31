extends CharacterBody2D
class_name Player

@export var move_speed := 200
@export var max_health := 3

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(_delta):
	handle_movement()
	#handle_animations()


func handle_movement():
	var input_vector = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	velocity = input_vector * move_speed
	move_and_slide()

func handle_animations():
	if velocity != Vector2.ZERO:
		animated_sprite_2d.animation = 'run'
		if velocity > Vector2.ZERO: 
			animated_sprite_2d.flip_h = false
		elif velocity < Vector2.ZERO:
			animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.animation = 'idle'
