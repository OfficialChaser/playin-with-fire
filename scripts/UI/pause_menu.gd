extends Control

var enabled := false
var confirm := false
var confirmCONFIRM := false


func _ready():
	$"../GUI".blur_animation_player.play("blur_out")
	# has to have already been called before pause menu can be called
	
	await get_tree().create_timer(3).timeout # 3 seconds seems to be minimum pause wait possible (without fucking up lightning)
	enabled = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and enabled and GameManager.in_game:
		if !get_tree().paused:
			$"../GUI".blur_animation_player.play("blur_out")
			# can't play animations bcs they are paused
			show()
			get_tree().paused = true
		else:
			unpause()
	if not Input.is_action_pressed("spray") and confirm:
		confirmCONFIRM = true

func _unhandled_input(event: InputEvent) -> void:
	# print_debug("confirm: " + str(confirm))
	
	if get_tree().paused:
		if !confirm and !confirmCONFIRM:
			$Label.text = "Press any\nbutton to\nunpause"
		if event.is_action_pressed("spray") and not event.is_echo():
			if confirmCONFIRM:
				$Label.text = "quitting"
				get_tree().quit()
			else:
				$Label.text = "shoot again\nto quit"
				confirm = true
		elif event.is_pressed() and not event.is_echo(): # and not event.is_action("pause"): # redundant, as "pause" is handled
			unpause()

func unpause():
	get_tree().paused = false
	confirm = false
	confirmCONFIRM = false
	#$"../GUI".blur_animation_player.play("blur_in")
	# can't play animations bcs they are paused
	hide()


func _on_button_pressed() -> void:	
	if confirmCONFIRM:
		$Label.text = "quitting"
		confirmCONFIRM = false
		get_tree().quit()
	else:
		$Label.text = "press again\nto quit"
		confirmCONFIRM = true
