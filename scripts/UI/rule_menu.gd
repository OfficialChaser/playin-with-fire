extends Control
class_name RuleMenu

@onready var title_label = $TitleLabel
@onready var rule_label = $RuleLabel
@onready var nerf_label = $TextureRect/NerfLabel
@onready var buff_label = $TextureRect/BuffLabel
@onready var cool_label = $TextureRect/CoolLabel
@onready var reroll_label = $RerollButton/RerollLabel

@onready var reroll_button = $RerollButton

@onready var animation_player = $AnimationPlayer
@onready var keyboard = $TextureRect/Keys

@onready var anim = $greg/AnimationPlayer

var start = true
var rule : Rule

var rerolling := false
var enabled := false
var selectable := false
var selecting_rule := false
func _ready():
	$RerollButton/OutOfStock.visible = false
	if RuleManager.player_has_maxed_out():
		ready_to_start(false)
	elif GameManager.day > 1:
		title_label.text = "[wave amp=60 freq=5]Today's Forecast[/wave]"
		get_new_rule()
		enabled = true
		
		await anim.animation_finished
		selecting_rule = false
		selectable = true

func _process(_delta):
	if not enabled:
		visible = false
		return
	visible = true
	if !rerolling and selectable:
		if Input.is_action_just_pressed("reroll"):
			if GameManager.rerolls == 0 or RuleManager.used_rules.size() == RuleManager.rules.size():
				reroll()
		elif Input.is_action_just_pressed('spray') and !reroll_button.is_hovered() and !selecting_rule:
			RuleManager.select_rule()
			selecting_rule = true
			anim.play("leave")
			await anim.animation_finished
			Transition.play("fade_in")
			await Transition.animation_finished
			ready_to_start()
	
	if GameManager.rerolls == 0 or RuleManager.used_rules.size() == RuleManager.rules.size() or !GameManager.roll_tmrw:
		reroll_button.disabled = true
		$RerollButton/OutOfStock.visible = true

func get_new_rule():
	rule = RuleManager.pick_random_rule()
	var mod = ""
	if RuleManager.rule_levels[rule] == 2:
		mod = " II"
	elif RuleManager.rule_levels[rule] == 3:
		mod = " III"
	rule_label.text = rule.rule_name + mod

	reroll_label.text = "Rerolls: " + str(GameManager.rerolls)
	
	update_rule_card_ui()

func update_rule_card_ui():
	keyboard.visible = false
	
	if start:
		anim.play("enter_2")
	else:
		anim.play("enter")
	
	if rule:
		rule.set_rule_text(self,RuleManager.rule_levels[rule])
	
	change_animations()

func _on_reroll_button_pressed():
	if selectable:
		reroll()

func ready_to_start(new_rule: bool = true):
	start = true
	enabled = false
	Transition.play("fade_out")
	if !GameManager.roll_tmrw:
		GameManager.roll_tmrw = true
	if new_rule:
		GameManager.rule_selected.emit(RuleManager.current_rule) # they'll still stack tho
	else:
		RuleManager.current_rule = null
		GameManager.rule_selected.emit(RuleManager.current_rule)

func reroll():
	start = false
	if rerolling or GameManager.rerolls < 1:
		return
	
	GameManager.rerolls -= 1
	GameManager.rerolls = clamp(GameManager.rerolls, 0, 10)
	rerolling = true
	get_new_rule()
	

func change_animations():
	await anim.animation_finished
	anim.play("idle")
	rerolling = false
