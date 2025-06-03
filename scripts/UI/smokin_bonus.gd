extends RichTextLabel

@onready var you_survived_label = $"../YouSurvivedLabel"

var time := 0.0
var color_list = [
	Color8(112, 56, 67),   # 703843
	Color8(67, 58, 93),    # 433a5d
	Color8(63, 88, 134),   # 3f5886
	Color8(63, 121, 134),  # 3f7986
	Color8(83, 154, 125),  # 539a7d
	Color8(115, 160, 107), # 73a06b
	Color8(198, 180, 79),  # c6b44f
	Color8(235, 238, 182)  # ebeeb6
]

@export var wave_amplitude := 3.0 # affects font size offset
@export var wave_speed := 4.0
@export var color_speed := 4.0
@export var base_font_size := 35

var original_text := "SMOKIN' BONUS"

func _ready():
	bbcode_enabled = true
	scroll_active = false
	set_process(true)
	
	# Disabling visibility
	you_survived_label.visible = false
	visible = false

func _process(delta):
	time += delta
	var bbcode = ""
	for i in original_text.length():
		var _char = original_text[i]
		if _char == " ":
			bbcode += " "
			continue
		
		# Color cycling
		var color_index = int(fmod(time * color_speed + i, color_list.size()))
		var col = color_list[color_index]
		var hex = col.to_html(false)

		# Sine wave "height" -> change font size
		var offset = sin(time * wave_speed + i * 0.4) * wave_amplitude
		var _size = base_font_size + offset

		bbcode += "[color=" + hex + "][font_size=" + str(int(_size)) + "]" + _char + "[/font_size][/color]"

	text = bbcode
