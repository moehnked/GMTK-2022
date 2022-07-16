extends Node


var diceArray = []

# Called when the node enters the scene tree for the first time.
func _ready():
	diceArray = self.get_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("dice_roll"):
		for die in diceArray:
			die.roll_die()
			
	if Input.is_action_just_pressed("finalize_roll"):
		finalize_roll()
			
	if Input.is_action_just_pressed("read_value"):
		for die in diceArray:
			print("in Manager: ", die.read_face())

func finalize_roll ():
	for die in diceArray:
		print("in Manager: ", die.read_face())




