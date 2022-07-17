extends Control

#Handles display, animation, and signaling for the Navigation Phase event options
var option = preload("res://Prefabs/UI/NavigationOption.tscn")
var options = []

var fireemitter = preload("res://Prefabs/Environmental/Firebolt.tscn")

signal event_triggered

var selectedOption = null

export var tweenSpeed = 1.1 #Seconds to arrive on-screen
export var dist = 320 #How far to display from center of screen
export var vertscale = 1.2 #Distorts the y-axis of the display area up so that labels have better vertical spacing

var centerpos

func _ready():
	centerpos = self.rect_position + self.rect_size/2
	SetupDisplayCurve()
	AddOption("Dread On Open Water","ev1")
	AddOption("A Serpent, Writhing","ev2")
	AddOption("The Too-Quiet Cove","ev3",["d:3|3"])
	AddOption("Is That...Singing?","ev4",["d:1|4"])
	AddOption("Is That...Singing?","ev4",["d:6|1|1|1"])
	AddOption("A Storm In Red","ev4",["d:1|2"],"storm_safe_1","The Eye Of The Storm")
	AddOption("Is That...Singing?","ev4",["d:3"])
	AddOption("A Sucking Slime Sea","ev4",["d:2|2|2","c:1"])
	AddOption("Land, Ho!","ev5",["d:3|1|4"])
	AddOption("He Who Came Before","ev0")
	SetNavigationOptionsStart()
	update()
	yield(get_tree().create_timer(0.5), "timeout")
	DisplayNavigationOptions()
	yield(get_tree().create_timer(2.5), "timeout")
	dice_roll_effect([1,3,5,6,3,2])
	#UndisplayNavigationOptions()

func SetupDisplayCurve():

	var c = Curve2D.new()
	c.add_point(self.rect_size / 2 + Vector2(dist*vertscale,0).rotated(PI/2))
	c.add_point(self.rect_size / 2 + Vector2(dist,0))
	c.add_point(self.rect_size / 2 + Vector2(dist*vertscale,0).rotated(-PI/2))
	$DisplayCurve.curve = c

func _draw():
	for i in range(0,options.size()):
		if options.size() >1:
			$DisplayCurve/DisplayFinder.unit_offset = (1.0/float(options.size()-1)) * i
		else:
			$DisplayCurve/DisplayFinder.unit_offset = 0.5
		var desiredPosition = (($DisplayCurve/DisplayFinder.position) - self.rect_size/2) * 6.5 + self.rect_size/2 - options[i].rect_size/2
		draw_circle(desiredPosition,5,Color(1,1,0))

func SetNavigationOptionsStart():
	for i in range(0,options.size()):
		if options.size() >1:
			$DisplayCurve/DisplayFinder.unit_offset = (1.0/float(options.size()-1)) * i
		else:
			$DisplayCurve/DisplayFinder.unit_offset = 0.5
		var desiredPosition = (($DisplayCurve/DisplayFinder.position) - self.rect_size/2) * 10 + self.rect_size/2 - options[i].rect_size/2
		options[i].rect_position = desiredPosition

func DisplayNavigationOptions():
	#Unhide at start of tween
	for i in range(0,options.size()):
		if options.size() >1:
			$DisplayCurve/DisplayFinder.unit_offset = (1.0/float(options.size()-1)) * i
		else:
			$DisplayCurve/DisplayFinder.unit_offset = 0.5
		var desiredPosition = $DisplayCurve/DisplayFinder.position - options[i].rect_size/2
		$Tween.interpolate_property(options[i],"rect_position",options[i].rect_position,desiredPosition,tweenSpeed,Tween.TRANS_CUBIC,Tween.EASE_OUT,i*0.1)
	$Tween.start()

func UndisplayNavigationOptions():
	for i in range(options.size()):
		if !options[i].isSelected:
			if options.size() >1:
				$DisplayCurve/DisplayFinder.unit_offset = (1.0/float(options.size()-1)) * i
			else:
				$DisplayCurve/DisplayFinder.unit_offset = 0.5
			var desiredPosition = (($DisplayCurve/DisplayFinder.position) - self.rect_size/2) * 6.5 + self.rect_size/2 - options[i].rect_size/2
#			print("Setting Undisplay position: ",desiredPosition)
			$Tween.interpolate_property(options[i],"rect_position",options[i].rect_position,desiredPosition,tweenSpeed,Tween.TRANS_CUBIC,Tween.EASE_OUT,i*0.01)
	#Yield for tween completion, then hide
	$Tween.start()

func AddOption(n,ev,unlock=null,ct=null,ctn=null):
	var newop = option.instance()
	newop.setup(self,n,ev,unlock,ct,ctn)
	options.append(newop)
	self.add_child(newop)

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
#	emit_signal("end_phase",op)
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
