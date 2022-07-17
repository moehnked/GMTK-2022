extends Node2D

export(int) var distance_travelled setget set_distance;
export(int) var distance_to_go;

var leaguesLabel;
var shipSprite;
var startingPoint;
var endingPoint;

func set_progress( travelled, left ): 
	var progress = float(travelled) / float(left);
	var target = $StartingPoint.position.x + $StartingPoint.position.distance_to($Port.position) * progress;
	$Tween.interpolate_property($Ship, 'position:x', $Ship.position.x, target, 2, Tween.TRANS_ELASTIC)
	$Tween.start();
# Update the leagues to go label, tween the ship progress between ship starting point and port position
func set_distance(value):
	set_progress( value, distance_to_go);
	$LeaguesToGo.set_text(str(distance_to_go - value))
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartingPoint.position.y = $Port.position.y;
	$Ship.position = $StartingPoint.position;
	yield(get_tree().create_timer(2), "timeout");
	set_distance(50);
