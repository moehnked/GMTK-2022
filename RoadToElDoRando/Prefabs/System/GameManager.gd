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


var canExit = true
#template for gamestates is stored in a script as a dictionary, accessible from this static method
var gameState = GameStateTemplate.get_gamestate_template()
var fileString = "user://file_data.json"
var game_ended = false
var RNG = RandomNumberGenerator.new()

export(Array, Resource) var songs = []

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	initialize()
	game_ended = handle_phases()
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_released("escape") and canExit:
		exit()

func get_game_state():
	return gameState

func get_rng():
	return RNG

func initialize():
	RNG.seed = gameState["seed"]
	get_tree().call_group("GamestateObserver", "game_state_initialized")
	update_state( gameState )
	ready_music()

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
	$SuppliesDisplay.update_text( gameState.Ship.Supplies )
	$CrewDisplay.update_text( gameState.Ship.Crew )
	pass
	
func handle_phases():
	print("new round")
	if not $music.playing:
		ready_music()
#
#	$ExplorationManager.start_phase(gameState);	
#
#	update_state(yield($ExplorationManager, 'end_phase'));
#
#	if gameState.CurrentDistance >= gameState.PortDistance:
#		gameState.CurrentDistance = 0
#		var phaseRef = get_tree().get_nodes_in_group("Port")[0]
#		phaseRef.initialize(gameState)
#		update_state(yield(phaseRef, 'exited_port'));
#		gameState.Phase = 0
#		return handle_phases()
#
#	var navMgr = $"../UI/NavigationOptionsManager"
#	navMgr.startPhase( gameState )
#
#	var handoffObject = yield(self, 'navigation_phase_end');
#	gameState.Phase = 2;
#
#	gameState.Phase = 3;
#	emit_signal("event_phase_start");
#	#starts Event Phase
#	var phaseRef = get_tree().get_nodes_in_group("EventPhase")[0]
#	phaseRef.call("initialize",handoffObject, gameState)
#
#	update_state(yield(phaseRef, "emit_end_phase"));


	gameState.Phase = 4;
	var phaseRef = get_tree().get_nodes_in_group("RelicPhase")[0]
	phaseRef.call("initialize", gameState)
	update_state(yield(phaseRef, "emit_end_phase"));
		
	# End Phase
	gameState.Phase = 0
	if gameState.Ship.Crew <= 0:
		print("game over")
		get_tree().change_scene("res://Scenes/loseScreen.tscn")
		return true;
	elif gameState.Ship.Supplies > 0:
		gameState.Ship.Supplies -= gameState.Ship.Crew
		get_tree().call_group("SuppliesDisplay", "update_text", gameState.Ship.Supplies)
		$sfx_daily_consume.play()
	else:
		gameState.Ship.Crew -= 1
		get_tree().call_group("CrewDisplay", "update_text", gameState.Ship.Crew)
		$sfx_crewDies.play()
		if gameState.Ship.Crew <= 0:
			print("game over")
			get_tree().change_scene("res://Scenes/loseScreen.tscn")
			return true;
	print("round end")
	return handle_phases();


func load_game():
	var file = File.new()
	if not file.file_exists(fileString):
		RNG = RandomNumberGenerator.new()
		RNG.randomize()
		gameState["seed"] = RNG.seed
		save()
		return
	file.open(fileString, File.READ)
	gameState = parse_json(file.get_as_text())

func ready_music():
	$music.stream = songs[RNG.randi() % songs.size()]
	$music.play()

func save():
	var file = File.new()
	file.open(fileString, File.WRITE)
	file.store_line(to_json(gameState))
	file.close()

func exit():
	save()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
