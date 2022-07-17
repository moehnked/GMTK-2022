extends Node2D

signal end_phase

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var GameManager;
var DiceManager;

var _state;

# Called when the node enters the scene tree for the first time.
func _ready():
	DiceManager = get_tree().get_nodes_in_group('dice_manager')[0];
	GameManager = get_tree().get_nodes_in_group('game_manager')[0];

func start_phase( gameState ):
	_state = gameState;
	$AnimationPlayer.play("BeginPhase");
	DiceManager.connect('report_roll', self, 'handle_dice_roll');
	DiceManager.request_roll(4);
	
func handle_dice_roll( dice ):
	DiceManager.disconnect('report_roll', self, 'handle_dice_roll');
	print(dice);
	var sum = 0;
	for result in dice:
		sum = sum + dice[result];
	_state.CurrentDistance += sum;
#	_state.TotalDistance += sum;
	$ProgressTracker.set_progress(_state.CurrentDistance, _state.PortDistance);
	end_phase();
	
func end_phase():
	GameManager.emit_signal('end_phase', _state);
	$AnimationPlayer.play("EndPhase");
	
# BEGIN
# Animate controls in
# 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
