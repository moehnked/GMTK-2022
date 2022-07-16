extends Node2D


export(float) var rotSpeed = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees = lerp(rotation_degrees, rotation_degrees + rotSpeed, 0.5)
#	pass
