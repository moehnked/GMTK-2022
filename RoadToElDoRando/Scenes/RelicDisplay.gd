extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func update_text( value ):
	$RelicLabel.set_text( str(value));
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
