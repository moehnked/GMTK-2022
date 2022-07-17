extends Control


# Class for storing display and information about an event option in Navigation Phase

var diceDisplay = preload("res://Assets/UI/NavigationOptionDiceReq.tscn")

var diceTextures = ["res://Assets/UI/Dice Icons/dice-six-faces-one.png","res://Assets/UI/Dice Icons/dice-six-faces-two.png","res://Assets/UI/Dice Icons/dice-six-faces-three.png","res://Assets/UI/Dice Icons/dice-six-faces-four.png","res://Assets/UI/Dice Icons/dice-six-faces-five.png","res://Assets/UI/Dice Icons/dice-six-faces-six.png"]

var crewmemberTexture = "res://Assets/UI/icons/PNG/White/2x/massiveMultiplayer.png"

var manager = null

var eventID = "EMPTY_ID" #Which event is being referenced

var displayName = "TEST NAME"

var isLocked = true
var transformTo = null
var transformDisplay = null

var isSelected = false

var unlockRequirement = null #What is required to unlock it (dice, special, sacrifice, etc. If null, none)

var requirements = {} #Format is object:[Requirement, Value]
# 0 - Dice
# 1 - Crew

var diceRequirements = []
var crewRequirements = 0 #How many crew are killed by unlocking this option

func _ready():
	pass # Replace with function body.

func setup(man,n,event,unlockstr = null,tf = null,tfn=null):
	manager=man
	displayName = n
	eventID = event
	unlockRequirement = unlockstr
	transformTo = tf
	transformDisplay = tfn
	if unlockRequirement.size() == 0 or transformTo:
		isLocked=false
	UpdateSprite()
	RegisterUnlocks()

func deactivateRollRequirement(r): #Allocate a die roll and deactivate that die. If all are gone, lock breaks
	pass
	if r in diceRequirements:
		for req in requirements:
			if requirements[req][0] == 0 and requirements[req][1] == r:
				#requirements.erase(req)
				manager.get_node("Tween").interpolate_property(req,"modulate",req.modulate,Color(0.3,0.3,0.3),0.4,Tween.TRANS_LINEAR,Tween.EASE_IN,1.0)
				manager.get_node("Tween").start()
				requirements.erase(req)
				diceRequirements.erase(r)
				if diceRequirements.size() == 0 and crewRequirements == 0:
					if isLocked:
						unlock()
					elif transformTo:
						transform()
					else:
						print("Tried to unlock/transform an option without either state.")
				return true

func unlock():
	pass
	if isLocked:
	#Do dissolve of lock here
		manager.get_node("Tween").interpolate_property($Locked,"modulate",$Locked.modulate,$Locked.modulate - Color(0,0,0,2),0.7,Tween.TRANS_CUBIC,Tween.EASE_IN,1.6)
		manager.get_node("Tween").interpolate_property($Locked,"rect_position",$Locked.rect_position,$Locked.rect_position + Vector2(0,-10),0.7,Tween.TRANS_CUBIC,Tween.EASE_IN,1.6)
		manager.get_node("Tween").start()
		isLocked = false

func transform():
	pass
	#Spin the cycle logo and then become a different, better event
	manager.get_node("Tween").interpolate_property($Locked,"modulate",$Locked.modulate,$Locked.modulate - Color(0,0,0,2),0.7,Tween.TRANS_CUBIC,Tween.EASE_IN,1.6)
	manager.get_node("Tween").interpolate_property($Locked,"rect_rotation",$Locked.rect_rotation,$Locked.rect_rotation + 360,0.7,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT,1.6)
	manager.get_node("Tween").start()
	eventID = transformTo
	displayName = transformDisplay
	DissolveName()

func DissolveName():
	var label = $Label/EventName/CenterContainer/Name
	manager.get_node("Tween").interpolate_property(label,"modulate",label.modulate,label.modulate - Color(0,0,0,2),0.7,Tween.TRANS_CUBIC,Tween.EASE_IN,1.6)
	manager.get_node("Tween").start()
	yield(manager.get_node("Tween"),"tween_all_completed")
	label.text = displayName
	manager.get_node("Tween").interpolate_property(label,"modulate",label.modulate,Color(1,1,1,1),0.7,Tween.TRANS_CUBIC,Tween.EASE_OUT,0)
	manager.get_node("Tween").start()

func strip():
	#remove all excess stuff that isn't the banner and label
	manager.get_node("Tween").interpolate_property($Locked,"modulate",$Locked.modulate,Color(1,1,1,0),0.7,Tween.TRANS_CUBIC,Tween.EASE_OUT,0)
	for n in $Label/UnlockRequirement.get_children():
		manager.get_node("Tween").interpolate_property(n,"modulate",n.modulate,Color(1,1,1,0),0.7,Tween.TRANS_CUBIC,Tween.EASE_OUT,0)
	manager.get_node("Tween").start()
#
#	yield(manager.get_node("Tween"),"tween_all_completed")
#	for n in $Label/UnlockRequirement.get_children():
#		n.queue_free()

func UpdateSprite():
	$Label/EventName/CenterContainer/Name.text = displayName

func showActive():
	manager.get_node("Tween").interpolate_property($Label/EventName,"modulate",$Label/EventName.modulate,Color(1,1,1),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN,0)
	manager.get_node("Tween").start()

func RegisterUnlocks():
	if !isLocked and !transformTo:
		$Locked.visible = false
		return
	
	if transformTo:
		$Locked.texture = load("res://Assets/UI/cycle.png")
	
	for child in $Label/UnlockRequirement.get_children():
		child.queue_free()
	if unlockRequirement:
		for entry in unlockRequirement:
			var reqs = entry.split(",")
			for req in reqs:
				var s = req.split(":")
				var type = s[0]
				var spec = s[1]
				var data = spec.split("|")
				match type:
					'd':
						for d in data:
							var newd = diceDisplay.instance()
							$Label/UnlockRequirement.add_child(newd)
							newd.get_node("TextureRect").texture = load(diceTextures[int(d)-1]) #Set the die face to the corresponding number
							diceRequirements.append(int(d)) #Special numbers that indicate things like two of a kind, three of a kind, etc. All negative
							requirements[newd]=[0,int(d)]
					'c': #Crewmember sacrifice
						if int(data[0]) > 0:
							for i in data:
								var newd = diceDisplay.instance()
								$Label/UnlockRequirement.add_child(newd)
								newd.get_node("TextureRect").texture = load(crewmemberTexture) #Add a crewmember sprite for each one required
								requirements[newd]=[1,1]
	

func _on_TextureButton_pressed():
	print("Registered Click for Event: ",eventID)
	
	if !isLocked:
		manager.SelectOption(self)
