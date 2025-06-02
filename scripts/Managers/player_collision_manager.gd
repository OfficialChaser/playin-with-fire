extends Node

# References
var player : CharacterBody2D

# Fire knockback variables
var fire_knockback_force := 8000.0
var fire_damage := 10
var knockback_dir
@onready var knockback_cooldown = $KnockbackCooldown

func _ready():
	player = get_parent()

func _physics_process(delta):
	handle_fire_collision()
	
	# If player movement disabled, apply knockback to player
	if !player.input_enabled:
		player.velocity = knockback_dir * fire_knockback_force * delta

func handle_fire_collision():
	var collision = player.get_last_slide_collision()
	if not collision or !knockback_cooldown.is_stopped():
		return
		
	var collider = collision.get_collider()
	if collider is FireTiles:
		# Initiate knockback
		knockback_dir = (player.global_position - collision.get_position()).normalized()
		knockback_cooldown.start()
		player.input_enabled = false
		
		# Update camera
		player.main_camera.apply_shake(3, 6)
		player.main_camera.play_red_tint_anim()
		
		# Add damage to player
		GameManager.damage_player(fire_damage)

func _on_knockback_cooldown_timeout():
	player.acc = 0
	player.input_enabled = true
