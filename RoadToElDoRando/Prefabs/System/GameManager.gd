extends Node


signal exploration_phase_start
signal exploration_phase_end
signal navigation_phase_start
signal navigation_phase_end
signal event_phase_start
signal event_phase_end
signal end_phase_start
signal end_phase_end
signal game_lost
signal game_won
signal entered_port
signal exited_port

var gameState = {
	"seed":0,
	"Phase": 0,
	"Relics":0,
	"Ship":{
		"ShipType":{},
		"Supplies":10,
		"Crew":[],
		"Hull":5,
		"Statuses":{}
	},
	"Round":0,
	"PortDistance": 30,
	"PortsReached": 0,
	"CurrentDistance":0,
	"TotalDistance": 0,
	"events":{}
}
var fileString = "user://file_data.json"
var RNG = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	initialize()
	handle_phases()
	pass # Replace with function body.

func get_game_state():
	return gameState

func get_rng():
	return RNG

func initialize():
	RNG.seed = gameState["seed"]
	get_tree().call_group("GamestateObserver", "game_state_initialized")

# Necessary "Scenes"
# Exploration Phase
# Navigation Phase
# Event phase
# Relic phase
# Port
# End Phase
# Win Screen
# Lose Screen
# Game Summary

func update_state( data ):
	gameState = data;
	pass
	
func handle_phases():
	# PHASE 1: Exploration
	# Roll dice to determine how much progress is made towards port
	# If Progress > Dist. to Port, show Port scene
	# Else to Navigation Phase
	
	$ExplorationManager.start_phase(gameState);	
	
	update_state(yield($ExplorationManager, 'end_phase'));
	
	if gameState.CurrentDistance >= gameState.PortDistance:
		print('Entered Port!', gameState.CurrentDistance, ' ', gameState.PortDistance)
		emit_signal("entered_port");
		update_state(yield(self, 'exited_port'));
		return true;
		
	var navMgr = $"../UI/NavigationOptionsManager"
	navMgr.startPhase()
	
	var handoffObject = yield(self, 'navigation_phase_end');
		
	
	# Phase 2: Navigation Phase
	# Randomly select n events to choose from and assign dice requirements
	# Show Available Options
	# Roll Dice
	# Modify dice
	# Choose the event
	gameState.Phase = 2;
#	emit_signal("navigation_phase_start");
	
#	update_state(yield(self, 'navigation_phase_end'));
	
	# Phase 3: Event Phase
	# Show the name and description, move props on screen
	# Select an option from the list in the event definition
	# If the selected option has a dice requirement, roll dice
	# Display the rewards and costs
	gameState.Phase = 3;
	emit_signal("event_phase_start");
	
	#starts Event Phase
	var phaseRef = get_tree().get_nodes_in_group("EventPhase")[0]
	phaseRef.call("initialize",handoffObject, gameState)
	
	update_state(yield(phaseRef, "emit_end_phase"));
	
	# Phase 4: Relic Phase
	# Each relic you own is rolled in sequence. Boons/curses are applied.
	gameState.Phase = 3;
	#emit_signal("relic_phase_start");
	phaseRef = get_tree().get_nodes_in_group("RelicPhase")[0]
	phaseRef.call("initialize", gameState)
	update_state(yield(self, "emit_end_phase"));
		
	# End Phase
	# If at end phase your ship has 0 crew, the game is lost
	# Back to Exploration Phase
	gameState.Phase = 4
	emit_signal("end_phase_start");
	
	update_state(yield(self, "end_phase_end"));
	
	if gameState.Ship.Crew <= 0:
		emit_signal("game_lost");


func load_game():
	var file = File.new()
	if not file.file_exists(fileString):
		RNG.randomize()
		gameState["seed"] = RNG.seed
		save()
		return
	file.open(fileString, File.READ)
#	gameState = parse_json(file.get_as_text())


func save():
	var file = File.new()
	file.open(fileString, File.WRITE)
	file.store_line(to_json(gameState))
	file.close()
