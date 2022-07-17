extends Sprite
var wigglemat = preload("res://Assets/Materials/wiggle_shadermaterial.tres")
var optionNumber = 0
var isHovering = false
var text = "hello world"

signal emit_clicked(n)

# Called when the node enters the scene tree for the first time.
func _ready():
	unhover()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("select") and isHovering:
		emit_signal("emit_clicked", optionNumber)
	pass

func refresh_text():
	$RichTextLabel.bbcode_text = "[wave amp=60 freq=2]" + text + "[/wave]"

func unhover():
	$RichTextLabel.bbcode_text = text
	isHovering = false
	material = null

func _on_Panel_mouse_entered():
	isHovering = true
	refresh_text()
	material = wigglemat
	pass # Replace with function body.


func _on_Panel_mouse_exited():
	unhover()
	pass # Replace with function body.
