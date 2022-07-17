extends Node

signal report_roll(diceAr)
var dice_button;
var dice_array = []

# final_rolls is a dict object
# # key is the die object
# # value is the roll value
var final_rolls = {}

var die_prefab = preload("res://Dice_d6.tscn")
var test_spawn_position = Vector3(0,20,0)
var spawn_position = Vector3(0,5,-30)

var timer
const roll_time = 5

const escape_limit = -40


# Called when the node enters the scene tree for the first time.
func _ready():
	dice_array = $Dice.get_children()
	timer = $Timer
	timer.set_one_shot(true)
	timer.start(roll_time)
	timer.set_paused(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_for_escapes()
	# Roll all dice in the dome
	if Input.is_action_just_pressed("roll_dice"): # space
		roll_remaining_dice()

	# Roll all dice from the cup
	if Input.is_action_just_pressed("initial_roll"): # r
		full_roll(6)

	if timer.is_stopped():
		read_dice_values()

	# accept and read all values in the dome
	if Input.is_action_just_pressed("finalize_roll"): # w
		print(finalize_roll())

	# Spawn a single die
	if Input.is_action_just_pressed("spawn_die"): # e
		spawn_die()


func request_roll (n_dice, isRelicRoll = false):
	var g = get_tree().get_nodes_in_group("DiceButton")
	dice_button = g[0];
	if isRelicRoll:
		dice_button.enable_relic()
	else:
		dice_button.enable_roll()
	dice_button.connect("emit_roll_clicked", self, "full_roll", [n_dice], CONNECT_ONESHOT)


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
	if dice_array.size() != 0:
		for die in dice_array:
			despawn_die(die)
			dice_array.erase(die)
		print(dice_array)
	final_rolls.clear()
	spawn_dice(n_dice)
	initial_roll()

func emit_report_roll():
	emit_signal("report_roll", final_rolls)
	final_rolls.clear()

#### TODO Change later to get actual first roll ####
func initial_roll():
	for die in dice_array:
		die.roll_die(get_spawn_roll(die.transform.origin))
	timer.set_paused(false)
	timer.start(roll_time)

func check_for_escapes ():
	for die in dice_array:
		if die.transform.origin.y <= escape_limit:
			respawn(die)
			
func respawn(die):
	despawn_die(die)
	die = spawn_die()
	die.roll_die(get_spawn_roll(die.transform.origin))
	
			


func roll_remaining_dice ():
	for die in dice_array:
		die.reroll_die()
	timer.set_paused(false)
	timer.start(roll_time)

# reads the face values of every dice, seperating them into
# 	done dice and dice that must be rerolled
func read_dice_values ():
	var reroll = []
	while (dice_array.size() > 0):
		var die = dice_array.pop_back()
		var value = die.read_face()
		## if null, reroll
		if value == null:
			reroll.append(die)
		## else, count
		else:
			final_rolls[die] = value
			despawn_die(die)
	dice_array = reroll
	if dice_array.size() != 0:
		roll_remaining_dice()
		return false
	else:
		if final_rolls.size() > 0:
			emit_report_roll()
		for die in dice_array:
			despawn_die(die)
		dice_array.clear()
		timer.stop()
		return true

# manage the final count of dice
func finalize_roll ():
	return final_rolls

func despawn_die (die):
	remove_child(die)
	dice_array.erase(die)
	die.free()


func spawn_dice (n):
	for i in range(n):
		spawn_die()

func spawn_die():
	var die = die_prefab.instance()
	die.transform.origin = spawn_position
	add_child(die)
	dice_array.append(die)
	return die

func get_spawn_roll(pos):
	return (-pos).normalized()
