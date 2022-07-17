extends Node2D

export var supplies = 10 setget set_supplies;
export var crew = 10 setget set_crew;

var crew_label;
var supplies_label;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_crew( value ):
	crew_label.set_text(value);
	
func set_supplies( value ):
	supplies_label.set_text(value);

# Called when the node enters the scene tree for the first time.
func _ready():
	crew_label = $CrewDisplay/CrewLabel;
	supplies_label = $SuppliesDisplay/SuppliesLabel;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
