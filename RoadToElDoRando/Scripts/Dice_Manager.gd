extends Node


var dice_array = []

# final_rolls is a dict object
# # key is the die object
# # value is the roll value
var final_rolls = {}

var die_prefab = preload("res://Dice_d6.tscn")
var spawn_position = Vector3(0,10,0)

var timer
const roll_time = 3

var exploration_unit

# Called when the node enters the scene tree for the first time.
func _ready():
	dice_array = $Dice.get_children()
	timer = $Timer
	timer.set_one_shot(true)
	timer.start(roll_time)
	timer.set_paused(true)
	
	exploration_unit = get_tree().get_nodes_in_group("ExplorationUnit")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Roll all dice in the dome
	if Input.is_action_just_pressed("roll_dice"):
		roll_remaining_dice()
	
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
	

func request_roll (n_dice):
	exploration_unit.enable_roll()
	exploration_unit.connect("emit_roll_clicked", self, "full_roll", [n_dice], CONNECT_ONESHOT)


# ask for a roll of n dice
# clear final_rolls
# roll n dice
# if a dice doesn't land
	# reroll it
# if it does, 
	# add the die object and roll value into final_rolls
	# despawn the die
# signal when all dice are done rolling
func full_roll (n_dice):
	if dice_array.size != 0:
		for die in dice_array:
			despawn_die(die)
	dice_array.clear()
	final_rolls.clear()
	spawn_dice(n_dice)
	initial_roll()
	report_roll()
	
func report_roll():
	emit_signal("report_roll", final_rolls)

#### Change later to get actual first roll ####
func initial_roll():
	roll_remaining_dice()
	

func roll_remaining_dice ():
	for die in dice_array:
		die.roll_dice_random()
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
			final_rolls[die] = value
			despawn_die(die)
	dice_array = reroll
	if dice_array.size() != 0:
		roll_remaining_dice()
		return false
	else:
		timer.stop()
		return true

# manage the final count of dice
func finalize_roll ():
	return final_rolls

func despawn_die (die):
	print("DIE DIE DIE")


func spawn_dice (n):
	for i in range(n):
		spawn_die()
		
func spawn_die():
	var die = die_prefab.instance()
	die.transform.origin = spawn_position
	add_child(die)
	dice_array.append(die)
	
	


