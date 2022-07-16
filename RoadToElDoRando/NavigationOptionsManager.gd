extends Control

#Handles display, animation, and signaling for the Navigation Phase event options
var option = preload("res://Prefabs/UI/NavigationOption.tscn")
var options = []

signal event_triggered

export var tweenSpeed = 1.1 #Seconds to arrive on-screen
export var dist = 320 #How far to display from center of screen
export var vertscale = 1.2 #Distorts the y-axis of the display area up so that labels have better vertical spacing


func _ready():
	SetupDisplayCurve()
	AddOption("Dread On Open Water","ev1")
	AddOption("A Serpent, Writhing","ev2")
	AddOption("The Too-Quiet Cove","ev3","d:3|3")
	AddOption("Is That...Singing?","ev4","d:1")
	AddOption("Is That...Singing?","ev4","d:6")
	AddOption("A Storm In Red","ev4","d:1")
	AddOption("Is That...Singing?","ev4","d:3")
	AddOption("A Sucking Slime Sea","ev4","d:2|2|2")
	SetNavigationOptionsStart()
	update()
	yield(get_tree().create_timer(0.5), "timeout")
	DisplayNavigationOptions()
	yield(get_tree().create_timer(4.5), "timeout")
	UndisplayNavigationOptions()

func SetupDisplayCurve():

	var c = Curve2D.new()
	c.add_point(self.rect_size / 2 + Vector2(dist*vertscale,0).rotated(PI/2))
	c.add_point(self.rect_size / 2 + Vector2(dist,0))
	c.add_point(self.rect_size / 2 + Vector2(dist*vertscale,0).rotated(-PI/2))
	$DisplayCurve.curve = c

func _draw():
	for i in range(0,options.size()):
		$DisplayCurve/DisplayFinder.unit_offset = (1.0/float(options.size()-1)) * i
		var desiredPosition = (($DisplayCurve/DisplayFinder.position) - self.rect_size/2) * 6.5 + self.rect_size/2 - options[i].rect_size/2
		draw_circle(desiredPosition,5,Color(1,1,0))

func SetNavigationOptionsStart():
	for i in range(0,options.size()):
		$DisplayCurve/DisplayFinder.unit_offset = (1.0/float(options.size()-1)) * i
		var desiredPosition = (($DisplayCurve/DisplayFinder.position) - self.rect_size/2) * 10 + self.rect_size/2 - options[i].rect_size/2
		options[i].rect_position = desiredPosition

func DisplayNavigationOptions():
	#Unhide at start of tween
	for i in range(0,options.size()):
		$DisplayCurve/DisplayFinder.unit_offset = (1.0/float(options.size()-1)) * i
		var desiredPosition = $DisplayCurve/DisplayFinder.position - options[i].rect_size/2
		$Tween.interpolate_property(options[i],"rect_position",options[i].rect_position,desiredPosition,tweenSpeed,Tween.TRANS_CUBIC,Tween.EASE_OUT,i*0.1)
	$Tween.start()

func UndisplayNavigationOptions():
	for i in range(options.size()):
		$DisplayCurve/DisplayFinder.unit_offset = (1.0/float(options.size()-1)) * i
		var desiredPosition = (($DisplayCurve/DisplayFinder.position) - self.rect_size/2) * 6.5 + self.rect_size/2 - options[i].rect_size/2
		print("Setting Undisplay position: ",desiredPosition)
		$Tween.interpolate_property(options[i],"rect_position",options[i].rect_position,desiredPosition,tweenSpeed,Tween.TRANS_CUBIC,Tween.EASE_OUT,i*0.01)
	#Yield for tween completion, then hide
	$Tween.start()

func AddOption(n,ev,unlock=null):
	var newop = option.instance()
	newop.setup(self,n,ev,unlock)
	options.append(newop)
	self.add_child(newop)

func RemoveOption(op):
	if op in options:
		options.erase(op)
		

func ResortOptions():
	DisplayNavigationOptions()

func RaiseEvent(ev):
	emit_signal("event_triggered",ev)
