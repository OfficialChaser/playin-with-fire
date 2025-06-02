extends CharacterBody2D
class_name Player

# Player vars
@export var move_speed := 75
@export var starting_acc := 0.5
var acc := 0.5

var input_enabled := true

# Hose effects on player
@export var hose_knockback := 200
@export var hose_jitter_magnitude := 5
@export var hose_jitter_power := 100

# Onreadys
@onready var hose = $Hose
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_animation_player = $Sprite2D/AnimationPlayer
var main_camera : MainCamera

func _ready():
	main_camera = get_tree().get_first_node_in_group("main_camera")

func _physics_process(delta):
	if input_enabled:
		
		# lerping acceleration back to normal if knockback reset it
		if acc < starting_acc:
			acc = lerp(acc, starting_acc, 0.01)
		
		# Handling Input
		if Input.is_action_just_pressed('spray'):
			hose.spray()
			main_camera.apply_shake(2, 10)
		if Input.is_action_just_released('spray'):
			hose.spray(false)
		
		handle_movement(delta)
	else:
		hose.spray(false)
		
	move_and_slide()
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
		
		# Tried messing around with a jitter to make the knockback morew random
		# You can get rid of this if you dont want it
		var combined_direction = (spray_direction * knockback_weight + input_vector * move_weight).normalized()
		var jitter = Vector2(
			randf_range(-hose_jitter_magnitude, hose_jitter_magnitude), 
			randf_range(-hose_jitter_magnitude, hose_jitter_magnitude)
			) * hose_jitter_power
			
		velocity = velocity.move_toward(
			(combined_direction * hose_knockback) + jitter, 
			6 * hose_jitter_power * delta
			)

	else:
		velocity = lerp(velocity, input_vector * move_speed, acc)

	move_and_slide()

func handle_animations():
	if !input_enabled:
		sprite_animation_player.play("stunned")
	elif velocity.length() > 0.01:
		sprite_animation_player.play("run")
	else:
		sprite_animation_player.play("idle")
	
	# this doesnt work with your sprite sheet, but i kept
	# the animated sprite node (the slicing of the sprite sheet
	# threw things off)
	if hose.sprite.global_position > global_position: 
		sprite_2d.flip_h = false
		hose.sprite.flip_v = false
	elif hose.sprite.global_position < global_position:
		sprite_2d.flip_h = true
		hose.sprite.flip_v = true
