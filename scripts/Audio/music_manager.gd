extends AudioStreamPlayer

# Preloads
const GAME_MUSIC : AudioStream = preload("res://sounds/Fire Game Main Theme.wav")
const MENU_MUSIC : AudioStream = preload("res://sounds/Fire Game Main Menu.wav")

var current_music : AudioStream

func play_music(music: String = ""):
	if not music:
		playing = false
		
	if music == "game_music":
		volume_db = 0
		current_music = GAME_MUSIC
		stream = GAME_MUSIC
		playing = true
	if music == "menu_music":
		volume_db = 5
		current_music = MENU_MUSIC
		stream = MENU_MUSIC
		playing = true

# loop
func _on_finished():
	playing = true
