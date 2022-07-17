extends Node2D

signal progress_updated

export(int) var distance_travelled setget set_distance;
export(int) var distance_to_port;

var leaguesLabel;
var shipSprite;
var startingPoint;
var endingPoint;

func set_progress( travelled, left ): 
	var progress = float(travelled) / float(left);
	var target = $StartingPoint.position.x + $StartingPoint.position.distance_to($Port.position) * progress;
	set_distance( left - travelled);
	$Tween.interpolate_property($Ship, 'position:x', $Ship.position.x, target, 2, Tween.TRANS_SINE)
	$Tween.start();
# Update the leagues to go label, tween the ship progress between ship starting point and port position
func set_distance(value):
	$LeaguesToGo.set_bbcode(str('[center]' , value, '[/center]'))
	pass
	
func finish_update():
	emit_signal("progress_updated");

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.connect('tween_all_completed', self, 'finish_update')	
	$StartingPoint.position.y = $Port.position.y;
	$Ship.position = $StartingPoint.position;
