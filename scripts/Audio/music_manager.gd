extends AudioStreamPlayer

# Preloads
var game_music : AudioStream = preload("res://sounds/Fire Game Main Theme.wav")
var current_music : AudioStream

func play_music(music: String):
	if music == "game_music":
		current_music = game_music
		stream = game_music
		playing = true

func _process(_delta):
	if !playing:
		playing = true
	
