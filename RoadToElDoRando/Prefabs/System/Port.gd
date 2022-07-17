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
	$AnimationPlayer.play("default")
	yield($AnimationPlayer, 'animation_finished')
	$Container/SuppliesDisplay.update_text(gameState["Ship"]["Supplies"])
	$AudioStreamPlayer.play()
	replenish_supplies()
	$Timer.start()
	yield($Timer, 'timeout');
	exit_port();

func replenish_supplies():
	var ship = gameState["Ship"]
	if ship["Supplies"] < ship["MaxSupplies"]:
		ship["Supplies"] += 1
	else:
		gameState["Ship"]["Supplies"] = ship["MaxSupplies"]
	get_tree().call_group("SuppliesDisplay", "update_text", ship["Supplies"])
	

func exit_port():
	$AnimationPlayer.play("outro")	
	yield($AnimationPlayer, 'animation_finished')
	gameState["PortDistance"] += rng.randi_range(5,12)
	emit_signal("exited_port", gameState)
