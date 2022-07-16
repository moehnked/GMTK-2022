extends Panel

var isHovered = false

signal emit_selected(slot)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("emit_selected", get_node("SlotBanner/Slot"), "set_jiggle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var hoverOffset = 0 - (int(isHovered) * 20)
	rect_position.x = lerp(rect_position.x, hoverOffset, 0.5)
	if Input.is_action_just_released("select") and isHovered:
		emit_signal("emit_selected", self)
#	pass


func _on_RelicSlotButton_mouse_entered():
	isHovered = true
	get_node("SlotBanner/Slot").set_jiggle(0)
	pass # Replace with function body.


func _on_RelicSlotButton_mouse_exited():
	isHovered = false
	pass # Replace with function body.
