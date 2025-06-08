extends Control

var enabled := false
var confirm := false
var confirmCONFIRM := false
var cool := true #cooldown but bool
# ↑ just here so you don't flip in and out when pause is "held"

func _ready():
	$"../GUI".blur_animation_player.play("blur_out")
	# has to have already been called before pause menu can be called
	if GameManager.day > 1:
		await GameManager.rule_selected
	await get_tree().create_timer(3).timeout # 3 seconds seems to be minimum pause wait possible (without fucking up lightning)
	enabled = true

func _process(_delta: float) -> void:
	if GameManager.in_game:
		if Input.is_action_just_pressed("pause"):
			if !get_tree().paused and enabled and cool:
				$"../GUI".blur_animation_player.play("blur_out")
				# can't play animations bcs they are paused
				show()
				get_tree().paused = true
		else:
			cool = true
				

	if not Input.is_action_pressed("spray") and confirm:
		confirmCONFIRM = true

func _unhandled_input(event: InputEvent) -> void:
	# also called in hose.gd and game_over.gd and main.gd
	# print_debug("confirm: " + str(confirm))
	
	if get_tree().paused:
		'''if !confirm and !confirmCONFIRM:
			$Label.text = "Press any\nbutton to\nunpause"
		if event.is_action_pressed("spray") and not event.is_echo():
			if confirmCONFIRM:
				$Label.text = "quitting"
				get_tree().quit()
			else:
				$Label.text = "shoot again\nto quit"
				confirm = true'''
		if event.is_pressed() and not event.is_echo(): # and not event.is_action("pause"): # redundant, as "pause" is handled somewhere else (can't figure out where though)
			unpause()

func unpause():
	get_tree().paused = false
	confirm = false
	confirmCONFIRM = false
	cool = false
	# just here so you don't flip in and out when pause is "held"
	#$"../GUI".blur_animation_player.play("blur_in")
	# isn't needed as we are using the fact that animations get paused for our gain here
	# instead of a blur_in animation, we use a blur_out one
	hide()


# Not working rn
'''func _on_button_pressed() -> void:
	GameManager.end_game()
	GameManager.reset_vars()
	Transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")'''
