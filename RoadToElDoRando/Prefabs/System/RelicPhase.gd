extends Node2D

signal emit_end_phase(gs)

var diceButton
var diceMgr
var gameState = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(_gamestate):
	gameState = _gamestate
	diceMgr = get_tree().get_nodes_in_group('dice_manager')[0];
	diceMgr.connect('report_roll', self, 'resolve_relic_rolls');
	diceMgr.request_roll(6, true);
	#diceButton = get_tree().get_nodes_in_group("DiceButton")[0]
	#diceButton.enable_relic()
	#diceButton.connect("emit_roll_clicked", self, "roll_relic")

func resolve_relic_rolls(ary):
	print(ary)
	diceMgr.disconnect('report_roll', self, 'dice_roll_effect');
	emit_signal("emit_end_phase", gameState)
	

func roll_relic():
	diceButton.disconnect("emit_roll_clicked", self, "roll_relic")
