extends Node

var gameState = {
	"seed":0,
	"Relics":{},
	"Ship":{
		"ShipType":{},
		"Supplies":10,
		"Crew":[],
		"Hull":5,
		"Statuses":{}
	},
	"Round":0,
	"PortDistance":4,
	"PortsReached": 0,
	"CurrentDistance":0,
	"totalDistance": 0,
	"events":{}
}
var fileString = "user://file_data.json"
var RNG = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	initialize()
	pass # Replace with function body.

func get_game_state():
	return gameState

func get_rng():
	return RNG

func initialize():
	RNG.seed = gameState["seed"]
	get_tree().call_group("GamestateObserver", "game_state_initialized")

func load_game():
	var file = File.new()
	if not file.file_exists(fileString):
		RNG.randomize()
		gameState["seed"] = RNG.seed
		save()
		return
	file.open(fileString, File.READ)
	gameState = parse_json(file.get_as_text())


func save():
	var file = File.new()
	file.open(fileString, File.WRITE)
	file.store_line(to_json(gameState))
	file.close()
