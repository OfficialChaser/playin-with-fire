extends Control

@onready var title_label = $TitleLabel
@onready var rule_label = $RuleLabel
@onready var nerf_label = $TextureRect/NerfLabel
@onready var buff_label = $TextureRect/BuffLabel
@onready var reroll_label = $RerollButton/RerollLabel

@onready var reroll_button = $RerollButton

@onready var animation_player = $AnimationPlayer


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
		RuleManager.clear_used_rules()
		animation_player.play("fade_out")

func get_new_rule():
	rule = RuleManager.pick_random_rule()
	rule_label.text = rule
	reroll_label.text = "Rerolls: " + str(GameManager.rerolls)
	update_rule_card_ui()

func update_rule_card_ui():
	if rule == "double trouble":
		nerf_label.text = "Double recoil"
		buff_label.text = "Double damage"

	elif rule == "lose a key":
		nerf_label.text = "Cannot move up"
		buff_label.text = "Double move speed"

func _on_reroll_button_pressed():
	if rerolling:
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
