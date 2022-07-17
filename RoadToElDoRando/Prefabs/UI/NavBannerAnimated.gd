extends Node2D

export(bool) var isHoverable = false
export(String) var initialText = "hello world"
export(bool) var revealOnReady = true

var isSelected = true

signal emit_clicked()

# Called when the node enters the scene tree for the first time.
func _ready():
	if revealOnReady:
		reveal(initialText)
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_released("select") and isSelected:
		emit_signal("emit_clicked")
	pass

func hover():
	if isHoverable:
		$AnimationPlayer.play("hover")

func reveal(text = "hello world"):
	$Container/Banner/RichTextLabel.bbcode_text = "[wave amp=50 freq=2]" + text + "[/wave]"
	$AnimationPlayer.play("reveal")

func set_text(text):
	initialText = text

func show():
	reveal(initialText)

func stop_hover():
	$AnimationPlayer.seek(0, true)
	$AnimationPlayer.stop()
	modulate = Color(1,1,1,1)
