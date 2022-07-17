extends RigidBody

var side_raycasts = []

# Called when the node enters the scene tree for the first time.
func _ready():
	side_raycasts = [$Cast_1,$Cast_2,$Cast_3,$Cast_4,$Cast_5,$Cast_6]
	pass # Replace with function body.
	
func _process(delta):
	if self.is_sleeping():
		self.mode = RigidBody.MODE_STATIC

func _physics_process(delta):
	if Input.is_action_just_pressed("select"):
		var die = select_dice()
		if die != null:
			die.roll_die()

func read_face ():
	for i in range(side_raycasts.size()):
		side_raycasts[i].force_raycast_update()
		if side_raycasts[i].is_colliding():
#			var collider = side_raycasts[i].get_collider()
			return 7 - (i + 1)

func select_dice ():
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
	
func roll_die ():
	self.mode = RigidBody.MODE_RIGID
	self.set_sleeping(false)
	var force_vector = Vector3.UP
	force_vector.rotated(Vector3.LEFT, 2 * PI * randf())
	force_vector.rotated(Vector3.UP, 2 * PI * randf())
	force_vector.rotated(Vector3.FORWARD, 2 * PI * randf())
	self.apply_central_impulse(force_vector * 100)
