extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func new_game():
	print("new game")
	var dir = Directory.new()
	dir.remove("user://file_data.json")
	var file = File.new()
	file.open("user://file_data.json", File.WRITE)
	file.store_line(to_json(GameStateTemplate.get_gamestate_template()))
	file.close()
	ready_fadeout()

func exit():
	get_tree().quit()

func ready_fadeout():
	$menuOptionContainer.visible = false
	$AnimationPlayer.play("fadeout")

func next_scene():
	get_tree().change_scene("res://Scenes/GameScreen.tscn")
	pass
