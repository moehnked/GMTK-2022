extends Sprite


var jiggle_ammount = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	jiggle()

func jiggle():
	jiggle_ammount = -jiggle_ammount
	jiggle_ammount += -sign(jiggle_ammount) * 3
	rotation_degrees += jiggle_ammount
	if jiggle_ammount == 0:
		rotation_degrees = 0

func set_jiggle(n):
	jiggle_ammount = 30
	
