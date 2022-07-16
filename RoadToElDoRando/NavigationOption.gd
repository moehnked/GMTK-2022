extends Control


# Class for storing display and information about an event option in Navigation Phase

var diceDisplay = preload("res://Assets/UI/NavigationOptionDiceReq.tscn")

var diceTextures = ["res://Assets/UI/Dice Icons/dice-six-faces-one.png","res://Assets/UI/Dice Icons/dice-six-faces-two.png","res://Assets/UI/Dice Icons/dice-six-faces-three.png","res://Assets/UI/Dice Icons/dice-six-faces-four.png","res://Assets/UI/Dice Icons/dice-six-faces-five.png","res://Assets/UI/Dice Icons/dice-six-faces-six.png"]

var manager = null

var eventID = "EMPTY_ID" #Which event is being referenced

var displayName = "TEST NAME"

var isLocked = false

var isSelected = false

var unlockRequirement = null #What is required to unlock it (dice, special, sacrifice, etc. If null, none)

func _ready():
	pass # Replace with function body.

func setup(man,n,event,unlockstr = null):
	manager=man
	displayName = n
	eventID = event
	unlockRequirement = unlockstr
	UpdateSprite()
	RegisterUnlocks()

func UpdateSprite():
	$Label/EventName/CenterContainer/Name.text = displayName

func RegisterUnlocks():
	for child in $Label/UnlockRequirement.get_children():
		child.queue_free()
	if unlockRequirement:
		var reqs = unlockRequirement.split(",")
		for req in reqs:
			var s = req.split(":")
			var type = s[0]
			var spec = s[1]
			print("Registered requirement of type '",type,"' with spec '",spec,"'")
			match type:
				'd':
					var dice = spec.split("|")
					for d in dice:
						var newd = diceDisplay.instance()
						$Label/UnlockRequirement.add_child(newd)
						newd.get_node("TextureRect").texture = load(diceTextures[int(d)-1]) #Set the die face to the corresponding number
						newd.rect_size = Vector2(32,32)
	
	

func TestUnlock(req):
	pass

func _on_TextureButton_pressed():
	print("Registered Click for Event: ",eventID)
