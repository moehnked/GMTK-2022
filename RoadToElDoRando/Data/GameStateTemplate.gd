extends Node


const template = {
	"seed":0,
	"phase": 0,
	"ship":{
		"maxsupplies":99,
		"supplies":9,
		"crew":4,
		"relic":0
	},
	"round":0,
	"portdistance": 7,
	"portsreached": 0,
	"currentdistance":0,
	"totaldistance": 0,
	"events":{}
}

static func get_gamestate_template():
	return template
