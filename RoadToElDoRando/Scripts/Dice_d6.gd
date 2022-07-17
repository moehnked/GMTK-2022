extends RigidBody

var side_raycasts = []

var passed_through_dome
var dome_checker

# Called when the node enters the scene tree for the first time.
func _ready():
	side_raycasts = [$Cast_1,$Cast_2,$Cast_3,$Cast_4,$Cast_5,$Cast_6]
	
	## the die will not interact with the dome the first time it hits it
	passed_through_dome = false
	self.set_collision_layer_bit (4, false)
	dome_checker = $DomeChecker
	
	
func _process(delta):
	if self.is_sleeping():
		self.mode = RigidBody.MODE_STATIC

func _physics_process(delta):
	
	# when die is left-clicked
	if Input.is_action_just_pressed("select"):
		select_die()
#	if not passed_through_dome:
#		dome_check()

# Check if this die has passed through the dome for the first time
#func dome_check ():

# checks for which raycast is interacting with the floor
#	and returns the value of the opposite face
func read_face ():
	for i in range(side_raycasts.size()):
		side_raycasts[i].force_raycast_update()
		if side_raycasts[i].is_colliding():
#			var collider = side_raycasts[i].get_collider()
			return 7 - (i + 1)

func select_die ():
	var die = get_selected_collider()
	if die != null:
		die.roll_die()
	
func get_selected_collider():
	var ray_length = 500
	var camera = get_viewport().get_camera()
	var mousePos = camera.get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mousePos)
	var to = from + camera.project_ray_normal(mousePos) * ray_length
	var space = get_world().direct_space_state
	var collision_mask = 1 << 2
	var result = space.intersect_ray (from, to,[] , collision_mask)
	if "collider" in result:
		return result.collider
	return null
	
func roll_die (var dir: Vector3):
	self.mode = RigidBody.MODE_RIGID
	self.set_sleeping(false)
	self.apply_central_impulse(dir * 100)

func reroll_die ():
	self.mode = RigidBody.MODE_RIGID
	self.set_sleeping(false)
	var force_vector = Vector3.UP
	force_vector.rotated(Vector3.LEFT, 2 * PI * randf())
	force_vector.rotated(Vector3.UP, 2 * PI * randf())
	force_vector.rotated(Vector3.FORWARD, 2 * PI * randf())
	self.apply_central_impulse(force_vector * 100)


func _on_DomeChecker_body_entered(body):
#	if body.name == "Dome":
#		print ("Dome!")
	pass # Replace with function body.
