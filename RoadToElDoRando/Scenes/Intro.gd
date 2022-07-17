extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		next_scene()

func next_scene():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	pass
