extends Node


var dice_array = []
var final_array = []

var die_prefab = preload("res://Dice_d6.tscn")

var timer
const roll_time = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	dice_array = $Dice.get_children()
	timer = $Timer
	timer.set_one_shot(true)
	timer.start(roll_time)
	timer.set_paused(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Roll all dice in the dome
	if Input.is_action_just_pressed("roll_dice"):
		roll_dice()
	
	if timer.is_stopped():
		read_dice_values()
	
	# accept and read all values in the dome
	if Input.is_action_just_pressed("finalize_roll"):
		finalize_roll()
	
	# Read the face values of all dice in the dome
	if Input.is_action_just_pressed("read_value"):
		for die in dice_array:
			print("in Manager: ", die.read_face())
	
	# Spawn a single die
	if Input.is_action_just_pressed("spawn_die"):
		spawn_die()

func roll_dice ():
	for die in dice_array:
		die.roll_die()
	timer.set_paused(false)
	timer.start(roll_time)

# reads the face values of every dice, seperating them into
# 	done dice and dice that must be rerolled
func read_dice_values ():
	var reroll = []
	while (dice_array.size() > 0):
		var die = dice_array.pop_back()
		var value = die.read_face()
		# if null, reroll
		if value == null:
			reroll.append(die)
		# else, count
		else:
			final_array.append(die)
			despawn_die(die)
	dice_array = reroll
	if dice_array.size() != 0:
		roll_dice()
	else:
		timer.stop()

# manage the final count of dice
func finalize_roll ():
	for die in final_array:
		print("in Manager: ", die.read_face())

func despawn_die (die):
	print("DIE DIE DIE")


func spawn_dice (n):
	for i in range(n):
		spawn_die()
		
func spawn_die():
	var spawn_position = Vector3(0,10,0)
	
	var die = die_prefab.instance()
	die.transform.origin = spawn_position
	add_child(die)
	dice_array.append(die)
	
	


