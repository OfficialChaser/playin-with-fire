extends Resource
class_name GameDefaults

const START_STATS := {
	# === Core Game State ===
	"day": 1,
	"in_game": true,
	"game_over": false,
	"rerolls": 3,
	"current_rule": null,

	# === Fire & Day System ===
	"fire_spawn_rate": 0.23,
	"day_duration": 40.0,  # was 45, reduced for pacing
	"lightning_spawn_amt": 5,
	"lightning_delay_time": 0.6,
	"shortened_day": false,

	# === Player Combat ===
	"player_health": 100,
	"player_damage": 2,
	"max_hp": 100,
	"hp_gain": 50,
	"regen": 50,
	"regen_enabled": false,

	# === Water / Hose Mechanics (Double Trouble) ===
	"hose_knockback": 30.0,
	"water_spawn_rate": 50.0,

	# === Blood Mode ===
	"water_color": Color("3f5886"),
	"blood_enabled": false,
	"player_blood_damage": 1,
	"blood_half": false,

	# === Gambling Addict ===
	"roll_tmrw": true,
	"deal_enabled": false,

	# === Darkness ===
	"darkness_enabled": false,
	"darkness_radius": 120.0,
	"spread": 10,

	# === Movement / Keys ===
	"player_move_speed": 75.0,
	"used_keys": [],
	"keys": [true, true, true, true],  # left, right, up, down

	# === Input Modes ===
	"look_mode": 4,  # InputMode.MOUSE
	"key_mode": 1    # InputMode.WASD
}
