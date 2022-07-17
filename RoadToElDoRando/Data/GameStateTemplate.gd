extends Node


const template = {
	"seed":0,
	"Phase": 0,
	"Relics":0,
	"Ship":{
		"MaxSupplies":1,
		"Supplies":1,
		"Crew":1,
	},
	"Round":0,
	"PortDistance": 6,
	"PortsReached": 0,
	"CurrentDistance":0,
	"TotalDistance": 0,
	"events":{}
}

static func get_gamestate_template():
	return template
