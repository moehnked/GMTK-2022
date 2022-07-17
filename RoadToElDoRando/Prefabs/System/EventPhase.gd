extends Node2D

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


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(e):
	event = e
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

func init_option(option_node, index):
	option_node.visible = event["options"].size() >= 1

func parse_option_selected(n):
	var op = event["options"][n]
	$ResultsText/RichTextLabel.bbcode_text = op.result.text
	$ResultsText/RichTextLabel.bbcode_text = "[center]"+$ResultsText/RichTextLabel.bbcode_text+"[/center]"
	$DescriptionAnimated/AnimationPlayer.play("HideOptions")
	pass

func _on_Timer_timeout():
	initialize(event)
	pass # Replace with function body.
