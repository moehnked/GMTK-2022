extends Control

#Handles display, animation, and signaling for the Navigation Phase event options
var option = preload("res://Prefabs/UI/NavigationOption.tscn")
var options = []

onready var gamemanager = get_node("/root/GameManager")

var fireemitter = preload("res://Prefabs/Environmental/Firebolt.tscn")

signal event_triggered

var selectedOption = null

var tweenSpeed = 1.1 #Seconds to arrive on-screen
var dist = 520 #How far to display from center of screen
var vertscale = 0.8 #Distorts the y-axis of the display area up so that labels have better vertical spacing

var centerpos

var event = {
	"id": "siren",
	"name": "Is that... Singing?",
	"score": 5,
	"description": "The whistling of the ocean breeze carries a haunting melody. After a moment, the lookout spots a small islet port-ward.",
	"options": [
		{
			"text": "Stay the course and put the wail out of your mind",
			"result": {
				"text": "The crew mutters at their work and tempers are high until the wailing falls out of earshot",
				"reward": [{"resource": "morale", "value": -1}]
			}
		},
		{
			"text": "Send a crew to investigate",
			"cost": [{"resource": "crew", "value": 1}],
			"result": {
				"text": "The sun falls below the horizon before the dinghy makes it back to the ship. The crew is gone, in their place a bright white bird's skull scoured clean by the salt water.",
				"reward": [{"resource": "relic_4", "value": 1}]
			}
		}, 
	]
}

func game_state_initialized():
	print("Navigation Manager Ready")

func _ready():
	pass
	
#	beginPhase()
#	yield($Tween,"tween_all_completed")
#	yield(get_tree().create_timer(0.5), "timeout")
#	dice_roll_effect([randi()%6+1,randi()%6+1,randi()%6+1,randi()%6+1,randi()%6+1,randi()%6+1])
	#UndisplayNavigationOptions()

func beginPhase():
	centerpos = self.rect_position + self.rect_size/2 + self.rect_size/5
#	for x in range(30):
	var elist = generateEventList()
	for e in elist:
		AddOption(e,e,elist[e])
	SetupDisplayCurve()
	update()
#	AddOption("Dread On Open Water","ev1")
#	AddOption("The Too-Quiet Cove","ev3",["d:3|3"])
#	AddOption("Is That...Singing?","ev4",["d:1|4"])
#	AddOption("A Storm In Red","ev4",["d:1|2"],"storm_safe_1","The Eye Of The Storm")
#	AddOption("Land, Ho!","ev5",["d:3|1|4"])
#	AddOption("He Who Came Before","ev0",["d:6"])
	SetNavigationOptionsStart()
	update()
	DisplayNavigationOptions()

func SetupDisplayCurve():

	var c = Curve2D.new()
	c.add_point(centerpos + Vector2(200,0))
	c.add_point(centerpos + Vector2(-600,-400))
	$DisplayCurve.curve = c

func _draw():
	for i in range(0,options.size()):
		if options.size() >1:
			$DisplayCurve/DisplayFinder.unit_offset = (1.0/float(options.size()-1)) * i
		else:
			$DisplayCurve/DisplayFinder.unit_offset = 0.5
#		var desiredPosition = ($DisplayCurve/DisplayFinder.position - centerpos) * 1.9 - options[i].rect_size/2 + centerpos
		var desiredPosition = Vector2(-600,-400) - Vector2(200,0) * 10 + centerpos
		draw_circle(desiredPosition,5,Color(1,1,0))

func SetNavigationOptionsStart():
	for i in range(0,options.size()):
		if options.size() >1:
			$DisplayCurve/DisplayFinder.unit_offset = (1.0/float(options.size()-1)) * i
		else:
			$DisplayCurve/DisplayFinder.unit_offset = 0.5
		var desiredPosition = Vector2(-600,-400) - Vector2(200,0) * 10 + centerpos
#		var desiredPosition = (($DisplayCurve/DisplayFinder.position) - centerpos) * 10 + centerpos - options[i].rect_size/2
		options[i].rect_position = desiredPosition

func DisplayNavigationOptions():
	#Unhide at start of tween
	for i in range(0,options.size()):
		if options.size() >1:
			$DisplayCurve/DisplayFinder.unit_offset = (1.0/float(options.size()-1)) * i
		else:
			$DisplayCurve/DisplayFinder.unit_offset = 0.5
		var desiredPosition = $DisplayCurve/DisplayFinder.position - (options[i].rect_size/4)
		$Tween.interpolate_property(options[i],"rect_position",options[i].rect_position,desiredPosition,tweenSpeed,Tween.TRANS_CUBIC,Tween.EASE_OUT,i*0.1)
	$Tween.start()

func UndisplayNavigationOptions():
	for i in range(options.size()):
		if !options[i].isSelected:
			if options.size() >1:
				$DisplayCurve/DisplayFinder.unit_offset = (1.0/float(options.size()-1)) * i
			else:
				$DisplayCurve/DisplayFinder.unit_offset = 0.5
			var desiredPosition = options[i].rect_position -Vector2(self.rect_size.x,0)
#			print("Setting Undisplay position: ",desiredPosition)
			$Tween.interpolate_property(options[i],"rect_position",options[i].rect_position,desiredPosition,tweenSpeed,Tween.TRANS_CUBIC,Tween.EASE_OUT,i*0.01)
	#Yield for tween completion, then hide
	$Tween.start()

func AddOption(n,ev,unlock=null,ct=null,ctn=null):
	var newop = option.instance()
	newop.setup(self,n,ev,unlock,ct,ctn)
	options.append(newop)
	$Options.add_child(newop)

func generateEventEntry(eventdict):
	pass

func RemoveOption(op):
	if op in options:
		options.erase(op)
		op.queue_free()

func SelectOption(op):
	if op in options:
		RaiseEvent(op)
		$Tween.interpolate_property(op,"rect_position",op.rect_position,$EventLocation.rect_position - op.rect_size/2,0.6,Tween.TRANS_CUBIC,Tween.EASE_OUT,1)
		$Tween.start()
	else:
		print("ERROR: OPTION NOT IN LIST")

func RaiseEvent(op):
	UndisplayNavigationOptions()
	GameManager.emit_signal("event_phase_end",1)
	print("Activated Event: ",op.eventID)
	yield($Tween,"tween_all_completed")
	for child in $Options.get_children():
		child.queue_free()
		options = []
		selectedOption = null

func dice_roll_effect(ary):
	print("Applying roll of ",ary)
	if selectedOption:
		return #Already picked, don't need to apply dice
	for roll in ary:
		for option in options:
			var success = option.deactivateRollRequirement(roll)
			if success:
				firebolt(option)
	#Take in an array of dice and apply them automatically to the locks present.

func firebolt(op):
	var lockpos = op.get_node("Locked").rect_position + op.rect_position + op.get_node("Locked").rect_size/2
	var bolt = fireemitter.instance()
	var delay = randf() * 0.3
	self.add_child(bolt)
	bolt.position = centerpos
#	print(centerpos)
	bolt.get_node("Tween").interpolate_property(bolt,"modulate",Color(0,0,0),Color(1,1,1),0.1,Tween.TRANS_LINEAR,delay)
	bolt.get_node("Tween").interpolate_property(bolt,"position",centerpos,lockpos,0.6,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT,delay)
	bolt.get_node("Tween").start()
	yield(bolt.get_node("Tween"),"tween_all_completed")
	bolt.lifetime = 0.9
	bolt.one_shot = true
	bolt.process_material.orbit_velocity = 0.0
	yield(get_tree().create_timer(1),"timeout")
	bolt.queue_free()


var eventlist = ["Dread On Open Water","Sharks!","The Red Storm","Unlucky Omen","Charred Albatross","Beguiling Merfolk","Paradise Grove","Missing First Mate","A Serpent Writhes","Crates, Adrift"]

func generateEventList():
	var rng = GameManager.get_rng()
	rng.randomize()
	var events = {}
	var options_num = [1,2,2,2,3,3,3,3,4,4,5,5] #How many events to generate
	var req_num = [4,3,2,2,2,2,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0]
	
	#Roll on a cascade of lists to determine the following:
	#Overall vibe (lots of calamity, lots of rest)
	#Check to make sure there's at least one no-cost option. if not, add a calamity
	var n = options_num[rng.randi()%options_num.size()-1]
	print("Number of events: ",n)
	for i in range(n):
		var rndindex = (rng.randi() % eventlist.size()-1)
		var chosenEvent = eventlist[rndindex]
		while(events.has(chosenEvent)):
			rndindex = (rng.randi() % eventlist.size()-1)
			chosenEvent = eventlist[rndindex]
		var requirementsNum = req_num[rng.randi() % req_num.size()-1]
		var requirements = []
		for j in range(requirementsNum):
			requirements.append(rng.randi()%6+1)
		#Check if the event has a transform, and if so, whether it passes the 50% chance to transform instead of lock
		var diceString = "d:"
		var requirementsFormatted = []
		for r in requirements:
			diceString = diceString + String(r) + '|'
		diceString = diceString.trim_suffix('|')
		if requirementsNum>0:
			requirementsFormatted.append(diceString)
		events[chosenEvent] = requirementsFormatted
		print("Event ",chosenEvent, " : ",requirementsFormatted)
	
	var isNoCostOption = false
	
	for entry in events: #Check if there's at least one option that can always be selected. TODO: Weight this to choose Calamity more often
		if events[entry].size() == 0:
			isNoCostOption = true
			break
	if isNoCostOption == false:
		print("Guaranteeing outcome")
		var rndindex = (rng.randi() % eventlist.size()-1)
		var newEvent = eventlist[rndindex]
		while events.has(newEvent):
			rndindex = (rng.randi() % eventlist.size()-1)
			newEvent = eventlist[rndindex]
		events[newEvent] = []
	
	print(events)
	return events
