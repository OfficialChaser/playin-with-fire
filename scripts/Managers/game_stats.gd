extends Node

# === Curve Preloads ===
const TIME_CURVE = preload("res://misc/time_curve.tres")
const DIFFICULTY_CURVE = preload("res://misc/difficulty_curve.tres")

# === Overarching stats ===
var day: int = 1
var has_selected_first_rule: bool:
	get:
		return day > 1
var rerolls: int = 3
var current_rule: Rule = null

# === Fire & Day System ===
var fire_spawn_rate: float = 0.23
var fire_damage: int = 10
var day_duration: float = 40.0
var lightning_spawn_amt: int = 5
var lightning_delay_time: float = 0.6
var shortened_day: bool = false

# === Player HP ===
var player_health: int = 100
var player_damage: int = 2
var max_hp: int = 100
var hp_gain: int = 50
var regen: int = 50
var regen_enabled: bool = false

# === Water / Hose Mechanics (Double Trouble) ===
var hose_knockback: float = 30.0
var water_spawn_rate: float = 50.0

# === Blood Mode ===
var water_color: Color = Color("3f5886")
var blood_enabled: bool = false
var player_blood_damage: int = 1
var blood_half: bool = false

# === Gambling Addict ===
var roll_tmrw: bool = true
var deal_enabled: bool = false

# === Darkness ===
var darkness_enabled: bool = false
var darkness_radius: float = 120.0
var spread: int = 10

# === Movement / Keys ===
var player_move_speed: float = 75.0
var used_keys: Array = []
var keys: Array = [true, true, true, true]  # left, right, up, down

# === Input Modes ===
var look_mode: int = 0  # InputMode.MOUSE
var key_mode: int = 1   # InputMode.WASD

# Curve Value Functions
func get_spawn_rate(difficulty_curve: Curve) -> float:
	if difficulty_curve:
		var day_clamped = clamp(day, 0, difficulty_curve.max_domain)
		return difficulty_curve.sample(day_clamped)
	else:
		push_warning("Spawn rate curve not set! Using fallback.")
		return 0.5

func get_day_duration(time_curve: Curve) -> float:
	if time_curve:
		var day_clamped = clamp(day, 0, time_curve.max_domain)
		return time_curve.sample(day_clamped)
	else:
		push_warning("Time curve not set! Using fallback.")
		return 30.0

# Update Vars Functions
func damage_player(damage: int):
	if GameManager.actively_playing:
		player_health -= damage

		if player_health <= 0:
			player_health = 0
			GameManager.end_game()

func heal_player(health: int):
	if GameManager.game_over:
		return
		
	player_health = min(health, max_hp)

func process_day_end(day_result: String):
	heal_player(player_health + hp_gain)

	day += 1
	fire_spawn_rate = get_spawn_rate(DIFFICULTY_CURVE)
	day_duration = get_day_duration(TIME_CURVE)
	lightning_spawn_amt += 1
	
	if day_result == "smokin' bonus":
		rerolls += 2
		
	if shortened_day:
		day_duration -= GameStats.day_duration * 0.3
	
	# Weird gambling addict thing i need to fix eventually
	'''if GameStats.deal_enabled:
		if randi_range(0, 1) == 1:
			player_health += 50
		elif player_health < 55:
			player_health = 5
		else:
			player_health -= 50'''
