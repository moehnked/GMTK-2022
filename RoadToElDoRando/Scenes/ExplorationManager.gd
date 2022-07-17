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
	$ProgressTracker.set_progress(gameState.CurrentDistance, gameState.PortDistance)
	DiceManager.connect('report_roll', self, 'handle_dice_roll');
	DiceManager.request_roll(gameState.Ship.Crew);
	
func handle_dice_roll( dice ):
	DiceManager.disconnect('report_roll', self, 'handle_dice_roll');
	print(dice);
	var sum = 0;
	for result in dice:
		sum = sum + dice[result];
	_state.CurrentDistance += sum;
	_state.TotalDistance += sum;
	$ProgressTracker.set_progress(_state.CurrentDistance, _state.PortDistance);
	yield($ProgressTracker, 'progress_updated');
	$AnimationPlayer.play('EndPhase');
	yield($AnimationPlayer, 'animation_finished');
	emit_signal('end_phase', _state);

	
# BEGIN
# Animate controls in
# 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
