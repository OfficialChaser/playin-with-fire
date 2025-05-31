extends CharacterBody2D
class_name Player

# Player vars
@export var max_health := 3
@export var move_speed := 200
@export var acc := 0.5

@export var hose_knockback := 200

# Onreadys
@onready var hose = $Hose
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta):
	# Handling Input
	if Input.is_action_just_pressed('spray'):
		hose.spray()
	if Input.is_action_just_released('spray'):
		hose.spray(false)

	handle_movement(delta)
	handle_animations()


func handle_movement(delta):
	# Get input
	var mouse_pos = get_global_mouse_position()
	var input_vector = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	
	if hose.spraying:
		var spray_direction = (global_position - mouse_pos).normalized()
		
		# Weight values: tweak these to tune how much movement vs. knockback matters
		# Probably wanna make sure they add up to one
		var knockback_weight = 0.8
		var move_weight = 0.2
		
		# Tried messing around with a jitter to make the knockback more random
		# You can get rid of this if you dont want it
		var combined_direction = (spray_direction * knockback_weight + input_vector * move_weight).normalized()
		var jitter = Vector2(randf_range(-5, 5), randf_range(-5, 5)) * 100
		velocity = velocity.move_toward((combined_direction * hose_knockback) + jitter, 600 * delta)

	else:
		velocity = lerp(velocity, input_vector * move_speed, acc)

	move_and_slide()


func handle_animations():
	if velocity != Vector2.ZERO:
		animated_sprite_2d.animation = 'run'
	else:
		animated_sprite_2d.animation = 'idle'
	
	# this doesnt work with your sprite sheet, but i kept
	# the animated sprite node (the slicing of the sprite sheet
	# threw things off)
	if hose.sprite.global_position > global_position: 
		animated_sprite_2d.flip_h = false
		hose.sprite.flip_v = false
	elif hose.sprite.global_position < global_position:
		animated_sprite_2d.flip_h = true
		hose.sprite.flip_v = true
	
