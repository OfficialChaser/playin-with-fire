extends Node

# References
var player : CharacterBody2D

# Fire knockback variables
var fire_knockback_force := 10000.0
var fire_damage := 10
var knockback_dir
@onready var knockback_cooldown = $KnockbackCooldown

func _ready():
	player = get_parent()

func _physics_process(delta):
	if not GameManager.in_game:
		return
	handle_fire_collision()
	
	# If player knockback enabled, apply knockback to player
	if player.knockback_enabled:
		player.velocity = knockback_dir * fire_knockback_force * delta

func handle_fire_collision():
	var collision = player.get_last_slide_collision()
	if not collision or !knockback_cooldown.is_stopped():
		return
		
	var collider = collision.get_collider()
	if collider is FireTiles:
		# Move into the tile that was actually hit
		var offset = -collision.get_normal() * 8.0  # Half-tile offset
		var adjusted_pos = collision.get_position() + offset
		var local_pos = collider.to_local(adjusted_pos)
		var tile_coords = collider.local_to_map(local_pos)

		var tile_data = collider.get_cell_tile_data(tile_coords)
		if !tile_data or tile_data and tile_data.get_custom_data("fire") == false:
			return  # Safe tile, skip

		# Apply knockback
		knockback_dir = (player.position - local_pos).normalized()
		knockback_cooldown.start()
		player.knockback_enabled = true
		
		# Camera effects
		player.main_camera.apply_shake(3, 6)
		player.main_camera.play_red_tint_anim()
		
		# Add damage
		GameManager.damage_player(fire_damage)



func _on_knockback_cooldown_timeout():
	player.acc = 0
	player.velocity = Vector2.ZERO
	player.knockback_enabled = false
