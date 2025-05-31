extends CharacterBody2D
class_name Player

@export var move_speed := 200
@export var max_health := 3

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hose_tracker: Marker2D = $HoseTracker
@onready var spray_particles: GPUParticles2D = $HoseTracker/Hose/SprayParticles
@onready var hose_ray: RayCast2D = $HoseTracker/Hose/HoseRay


var spraying : bool = false
@export var hose_knockback : float = 50.0

func _process(_delta):
	## Target hose to mouse
	var mouse_pos = get_global_mouse_position()
	hose_tracker.look_at(mouse_pos)
	
	##Handle Inputs
	## Spraying Hose
	if Input.is_action_just_pressed('spray'):
		spraying = true
		spray_particles.emitting = true

		hose_ray.force_raycast_update()
		if hose_ray.is_colliding():
			var target = hose_ray.get_collider()
			if target:
				target.queue_free() 
	
	## Stopping Spray
	if Input.is_action_just_released('spray'):
		spraying = false
		spray_particles.emitting = false

	handle_movement()
	handle_animations()


func handle_movement():
	## Can't Move while spraying/only apply knockback
	if spraying:
		var mouse_pos = get_global_mouse_position()
		var spray_direction = -(mouse_pos- global_position).normalized()
		velocity = spray_direction*hose_knockback
	else:
		## do movement
		var input_vector = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		).normalized()
		velocity = input_vector * move_speed
	move_and_slide()

func handle_animations():
	## Fix this so it only does while walking. Make a different case for spraying
	if velocity != Vector2.ZERO:
		animated_sprite_2d.animation = 'run'
		## Add sprite flip later, currently the sprite is asymmetric so it doesn't look right
		#if velocity > Vector2.ZERO: 
			#animated_sprite_2d.flip_h = false
		#elif velocity < Vector2.ZERO:
			#animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.animation = 'idle'
