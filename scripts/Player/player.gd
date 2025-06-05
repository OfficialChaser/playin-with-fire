extends CharacterBody2D
class_name Player

# Player vars
@export var starting_acc := 0.5
var acc := 0.5

var knockback_enabled := false
var paused := false

# Hose effects on player
var hose_knockback : int
@export var hose_jitter_magnitude := 2
@export var hose_jitter_power := 100

# Hose effects on camera
@export var hose_shake_strength := 1.0

# Onreadys
@onready var hose = $Hose
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_animation_player = $Sprite2D/AnimationPlayer
var main_camera : MainCamera

func _ready():
	main_camera = get_tree().get_first_node_in_group("main_camera")
	knockback_enabled = false

func _physics_process(delta):
	if paused:
		return
		
	if not GameManager.in_game:
		hose.spray(false)
		sprite_animation_player.play("idle")
		return
	if !knockback_enabled:
		# lerping acceleration back to normal if knockback reset it
		if acc < starting_acc:
			acc = lerp(acc, starting_acc, 0.01)
		
		# Handling Input
		if Input.is_action_just_pressed('spray'):
			hose.spray()
			main_camera.apply_shake(hose_shake_strength, 10)
		if Input.is_action_just_released('spray'):
			hose.spray(false)
		
		
	else:
		hose.spray(false)
	
	handle_movement(delta)
	move_and_slide()
	handle_animations()


func get_inputVector():
	var v = Vector2.ZERO
	# keys order is left right up down
	
	# 	x axis part
	if (GameManager.keys[0] and GameManager.keys[1]): # right and left keys are on
		v.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	elif (GameManager.keys[0]): #	left key is on, so right must be off
		v.x = - Input.get_action_strength("move_left")
	elif (GameManager.keys[1]): #	right key is on, so left must be off
		v.x = Input.get_action_strength("move_right")
	
	#	y axis part
	if (GameManager.keys[2] and GameManager.keys[3]): # up and down keys are on
		v.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	elif (GameManager.keys[2]): #	up key is on, so down must be off
		v.y = - Input.get_action_strength("move_up") 
	elif (GameManager.keys[3]): #	down key is on, so up must be off
		v.y = Input.get_action_strength("move_down")
	
	if !GameManager.keys[0] and Input.get_action_strength("move_left") or !GameManager.keys[1] and Input.get_action_strength("move_right"):
		if !$LockedSFX.playing:
			main_camera.apply_shake(1, 5)
			$LockedSFX.play()
	if !GameManager.keys[2] and Input.get_action_strength("move_up") or !GameManager.keys[3] and Input.get_action_strength("move_down"):
		if !$LockedSFX.playing:
			main_camera.apply_shake(1, 5)
			$LockedSFX.play()

	# normalise the vector no matter what
	return v.normalized()

func handle_movement(delta):
	var mouse_pos = get_global_mouse_position()
	# Get input
	var controller = -Vector2(
	 	Input.get_action_strength("look_right") - Input.get_action_strength("look_left"),
	 	Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	).normalized()
	
	var input_vector = get_inputVector()
	
	if hose.spraying:
		var spray_direction = controller
		if GameManager.look_mode == GameManager.InputMode.MOUSE:
			spray_direction = (global_position - mouse_pos).normalized()
			
		
		# Weight values: tweak these to tune how much movement vs. knockback matters
		# Probably wanna make sure they add up to one
		var knockback_weight = 0.95
		var move_weight = 0.05
		
		# Tried messing around with a jitter to make the knockback morew random
		# You can get rid of this if you dont want it
		var combined_direction = (spray_direction * knockback_weight + input_vector * move_weight).normalized()
		var jitter = Vector2(
			randf_range(-hose_jitter_magnitude, hose_jitter_magnitude), 
			randf_range(-hose_jitter_magnitude, hose_jitter_magnitude)
			) * hose_jitter_power
			
		velocity = velocity.move_toward(
			(combined_direction * GameManager.hose_knockback) + jitter, 
			6 * hose_jitter_power * delta
			)
	else:
		velocity = lerp(velocity, input_vector * GameManager.player_move_speed, acc)

	move_and_slide()

func handle_animations():
	if knockback_enabled:
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

func play_hit_sfx():
	$HitSFX.play()
