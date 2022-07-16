extends Node


var diceArray = []



# Called when the node enters the scene tree for the first time.
func _ready():
	diceArray = self.get_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		for die in diceArray:
			die.mode = RigidBody.MODE_RIGID
			die.set_sleeping(false)
			var force_vector = Vector3.UP
			force_vector.rotated(Vector3.LEFT, 2 * PI * randf())
			force_vector.rotated(Vector3.UP, 2 * PI * randf())
			force_vector.rotated(Vector3.FORWARD, 2 * PI * randf())
			die.apply_central_impulse(force_vector * 100)
			
	if Input.is_action_just_pressed("finalize_roll"):
		finalize_roll()
			
	if Input.is_action_just_pressed("read_value"):
		for die in diceArray:
			print("in Manager: ", die.read_face())

func finalize_roll ():
	for die in diceArray:
		print("in Manager: ", die.read_face())
	
