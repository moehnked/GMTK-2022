extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var side_raycasts = []

# Called when the node enters the scene tree for the first time.
func _ready():
	side_raycasts = [$Cast_1,$Cast_2,$Cast_3,$Cast_4,$Cast_5,$Cast_6]
	pass # Replace with function body.
	
func _process(delta):
	if self.is_sleeping():
		self.mode = RigidBody.MODE_STATIC


func read_face ():
	for i in range(side_raycasts.size()):
		side_raycasts[i].force_raycast_update()
		if side_raycasts[i].is_colliding():
			var collider = side_raycasts[i].get_collider()
			return 7 - (i + 1)
