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
#	$Timer.reset()

func replenish_supplies():
	var ship = gameState["Ship"]
	if ship["Supplies"] < ship["MaxSupplies"]:
		ship["Supplies"] += 1
		get_tree().call_group("SuppliesDisplay", "update_text", ship["Supplies"])
		$Timer.start()
	else:
		gameState["Ship"]["Supplies"] = ship["MaxSupplies"]
		$AnimationPlayer.play("outro")
		$Timer.stop()
		pass

func exit_port():
	gameState["PortDistance"] += rng.randi_range(5,12)
	emit_signal("exited_port", gameState)
