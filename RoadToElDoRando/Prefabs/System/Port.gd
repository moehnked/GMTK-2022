extends Node2D

signal exited_port(gs)

var gameState = {}
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(_gamestate):
	gameState = _gamestate
	rng.seed = gameState.seed
	$Container/SuppliesDisplay.update_text(gameState["ship"]["supplies"])
	$AnimationPlayer.play("default")
	yield($AnimationPlayer, 'animation_finished')
	$AudioStreamPlayer.play()
	replenish_supplies()
	$Timer.start()
	yield($Timer, 'timeout');
	exit_port();

func replenish_supplies():
	var ship = gameState["ship"]
	if ship["supplies"] <= ship["maxsupplies"]:
		ship["supplies"] += 1
	else:
		gameState["ship"]["supplies"] = ship["maxsupplies"]
	#get_tree().call_group("suppliesdisplay", "update_text", ship["supplies"])
	$Container/SuppliesDisplay.update_text(gameState["ship"]["supplies"])
	

func exit_port():
	$AnimationPlayer.play("outro")	
	yield($AnimationPlayer, 'animation_finished')
	gameState["portdistance"] += rng.randi_range(5,12)
	emit_signal("exited_port", gameState)
