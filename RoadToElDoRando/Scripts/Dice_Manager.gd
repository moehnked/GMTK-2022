extends Node


var diceArray = []



# Called when the node enters the scene tree for the first time.
func _ready():
	diceArray = self.get_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		for die in diceArray:
			var force_vector = Vector3.UP
			force_vector.rotated(Vector3.LEFT, 2 * PI * randf())
			force_vector.rotated(Vector3.UP, 2 * PI * randf())
			force_vector.rotated(Vector3.FORWARD, 2 * PI * randf())
			die.apply_central_impulse(force_vector * 100)
			
