extends RichTextLabel

export(String) var txt = "OPTION"

signal emit_clicked()

var isSelected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_text(txt)
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_released("select") and isSelected:
		emit_signal("emit_clicked")
		$click.play()

func set_text(t):
	txt = t
	bbcode_text = "[center]" + txt + "[/center]"

func hover():
	bbcode_text = "[center][wave amp=40]" + txt + "[/wave][/center]"
	$hover.play(0)
	isSelected = true

func unhover():
	set_text(txt)
	isSelected = false
