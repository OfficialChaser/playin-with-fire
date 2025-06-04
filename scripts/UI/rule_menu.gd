extends Control

@onready var title_label = $TitleLabel
@onready var rule_label = $RuleLabel
@onready var nerf_label = $TextureRect/NerfLabel
@onready var buff_label = $TextureRect/BuffLabel
@onready var cool_label = $TextureRect/CoolLabel
@onready var reroll_label = $RerollButton/RerollLabel

@onready var reroll_button = $RerollButton

@onready var animation_player = $AnimationPlayer
@onready var keyboard = $TextureRect/NerfLabel/Keys



var rule : String

var rerolling := false
var enabled := false

func _ready():
	if GameManager.day > 1:
		title_label.text = "Today's\n[wave amp=60 freq=5]Unpredictable Rule[/wave]"
		get_new_rule()
		enabled = true

func _process(_delta):
	if not enabled:
		visible = false
		return
	visible = true
	if Input.is_action_just_pressed('spray') and !rerolling and !reroll_button.is_hovered():
		RuleManager.select_rule()
		animation_player.play("fade_out")

func get_new_rule():
	rule = RuleManager.pick_random_rule()
	var mod = ""
	if RuleManager.rule_levels[rule] == 2:
		mod = " II"
	elif RuleManager.rule_levels[rule] == 3:
		mod = " III"
	rule_label.text = rule + mod
	reroll_label.text = "Rerolls: " + str(GameManager.rerolls)
	update_rule_card_ui()

func update_rule_card_ui():
	keyboard.visible = false
	cool_label.text = ""
	
	if rule == "double trouble":
		if RuleManager.rule_levels[rule] == 2:
			cool_label.text = "Fly"
		nerf_label.text = "Double recoil"
		buff_label.text = "Double damage"

	elif rule == "lose a key":
		keyboard.visible = true
		# keys = [["A", "D", "W", "S"], ["←", "→", "↑", "↓"], ["H", "L", "K", "J"]] + controller keys
		var thing
		if GameManager.look_mode == GameManager.InputMode.CONTROLLER:
			keyboard.frame = 12 + randi_range(0, 3)
			thing = "stick"
		else:
			var km : int = KeyManager.keys_layout()
			keyboard.frame = (km*4) - randi_range(1, 4) # (km-1)*4 + rng(0,3) 
			thing = "key"
		if RuleManager.rule_levels[rule] == 2:
			cool_label.text = "Reverse recoil"
		nerf_label.text = "Break the      " + thing
		buff_label.text = "Double move speed"
	elif rule == "cursor trap":
		if RuleManager.rule_levels[rule] == 2:
			cool_label.text = "Piercing water"
		nerf_label.text = "The cursor is stuck"
		buff_label.text = "Double spread" # two upgrades have this, maybe swap out ???
	elif rule == "save the trees": # most abstract
		if RuleManager.rule_levels[rule] == 2:
			cool_label.text = "Plant trees"  # could be hard to add
		nerf_label.text = "Burning trees steal HP"
		buff_label.text = "Heal from watered trees"
	elif rule == "bloody stuff":
		if RuleManager.rule_levels[rule] == 2:
			cool_label.text = "Blood pools" # might not be possible
		nerf_label.text = "Shooting hurts"
		buff_label.text = "Extra health"
	elif rule == "limited water":
		if RuleManager.rule_levels[rule] == 2:
			cool_label.text = "Unlimited sprinklers"
		nerf_label.text = "Ammo bar for water"
		buff_label.text = "Sprinklers"
	elif rule == "DARKNESS":
		if RuleManager.rule_levels[rule] > 1:
			cool_label.text = "Halved recoil"
		nerf_label.text = "Vision is limited"
		buff_label.text = "Double spread" # two upgrades have this, maybe swap out ???

func _on_reroll_button_pressed():
	if rerolling or GameManager.rerolls < 1:
		return
	
	GameManager.rerolls -= 1
	GameManager.rerolls = clamp(GameManager.rerolls, 0, 5)
	rerolling = true
	get_new_rule()
	
	# Placeholder
	await get_tree().create_timer(1).timeout
	rerolling = false

func ready_to_start():
	enabled = false
	GameManager.rule_selected.emit()
