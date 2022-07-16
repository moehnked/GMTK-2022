extends Node2D

export(NodePath) var crewlabel
export(NodePath) var suppliesLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func game_state_initialized():
	var gs = GameManager.gameState
	get_node(crewlabel).text = String(gs["Ship"]["Crew"].size())
	get_node(suppliesLabel).text = String(gs["Ship"]["Supplies"])
	
