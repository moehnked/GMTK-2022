extends Node2D

signal emit_end_phase(gs)

var eventlist

var event = {
	"name": "Is that... Singing?",
	"id":"siren",
	"score":5,
	"transform_to":"oracle",
	"transform_name":"Humming Soothsayer",
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

var gameState = {}
var isReadingResult = false
var targetEventBanner = null

# Called when the node enters the scene tree for the first time.
func _ready():
	ready_event_list()
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_released("select") and isReadingResult:
		isReadingResult = false
		$ClearResult.play()
		$DescriptionAnimated/AnimationPlayer.play("HideResults")
	if targetEventBanner != null:
		targetEventBanner.rect_position = targetEventBanner.rect_position.linear_interpolate($BannerPoint.position, 0.1)

func end_phase():
	print("ending phase")
	emit_signal("emit_end_phase", gameState)
	#modify game state
	#move on to next phase

func ready_event_list():
	var file = File.new()
	file.open("res://Data/eventslist.json", File.READ)
	eventlist = parse_json(file.get_as_text())
	print("Loaded eventlist")

func getEventlist():
	return eventlist

func setup_event():
	event = eventlist[targetEventBanner.eventID]
	$titleBanner.set_text(event["name"])
	$titleBanner.show()
	$DescriptionAnimated/Column1/Description/Label.text = event["description"]
	for i in range(3):
		var ob = get_node("DescriptionAnimated/Column1/Description/Option" + String(i + 1))
		if i < event["options"].size():
			ob.visible = true
			ob.text = event["options"][i].text
			ob.unhover()
			ob.optionNumber = i
		else:
			ob.visible = false
	$DescriptionAnimated/AnimationPlayer.play("reveal")

func initialize(e, _gamestate):
	targetEventBanner = e
	gameState = _gamestate
	setup_event()

func init_option(option_node, index):
	option_node.visible = event["options"].size() >= 1

func parse_option_selected(n):
	var op = event["options"][n]
	for r in op.result.reward:
		parse_reward(r)
	$OptionSelected.play()
	$ResultsText/RichTextLabel.bbcode_text = op.result.text
	$ResultsText/RichTextLabel.bbcode_text = "[center]"+$ResultsText/RichTextLabel.bbcode_text+"[/center]"
	$DescriptionAnimated/AnimationPlayer.play("HideOptions")
	targetEventBanner.queue_free()
	targetEventBanner = null
	pass

func parse_reward(reward):
	if "resource" in reward:
		update_resource(reward)
	pass

func update_resource(r):
	if "value" in r:
		gameState["Ship"][r.resource] += r.value
	elif "percent" in r:
		gameState["Ship"][r.resource] *= r.percent

func set_viewing_options():
	isReadingResult = true
