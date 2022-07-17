extends Node


const template = {
	"seed":0,
	"Phase": 0,
	"Relics":0,
	"Ship":{
		"MaxSupplies":99,
		"Supplies":5,
		"Crew":2,
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
