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

func _ready():
	centerpos = self.rect_position + self.rect_size/2 + self.rect_size/4
	for x in range(30):
		generateEventList()
	SetupDisplayCurve()
	update()
	AddOption("Dread On Open Water","ev1")
	AddOption("The Too-Quiet Cove","ev3",["d:3|3"])
	AddOption("Is That...Singing?","ev4",["d:1|4"])
	AddOption("A Storm In Red","ev4",["d:1|2"],"storm_safe_1","The Eye Of The Storm")
	AddOption("Land, Ho!","ev5",["d:3|1|4"])
	AddOption("He Who Came Before","ev0",["d:6"])
	SetNavigationOptionsStart()
	update()
	yield(get_tree().create_timer(0.5), "timeout")
	DisplayNavigationOptions()
	yield(get_tree().create_timer(2.5), "timeout")
	dice_roll_effect([1,3,5,6,3,2])
	#UndisplayNavigationOptions()

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
	self.add_child(newop)

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
	GameManager.emit_signal("end_phase",2)
	print("Activated Event: ",op.eventID)

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


var eventlist = ["ev1","ev2","ev3","ev4","ev5","ev6","ev7","ev8","ev9","ev10"]

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
	for i in range(n+1):
		var rndindex = round(rng.randi() % eventlist.size()-1)
		var chosenEvent = eventlist[rndindex]
		var requirementsNum = req_num[rng.randi() % req_num.size()-1]
		var requirements = []
		for j in range(requirementsNum):
			requirements.append(rng.randi()%7)
		#Check if the event has a transform, and if so, whether it passes the 50% chance to transform instead of lock
		
		events[chosenEvent] = requirements
	
	var isNoCostOption = false
	print(events)
	return events
