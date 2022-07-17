extends RichTextLabel


export(NodePath) var menuOptionContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		queue_free()
		get_node(menuOptionContainer).visible = true
		pass
#	pass
