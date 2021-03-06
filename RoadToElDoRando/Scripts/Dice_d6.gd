extends RigidBody

var side_raycasts = []

var passed_through_dome
var dome_checker
var dome_mask = 3
var cup_mask = 2

var roll_strength = 90
var reroll_strength = 40

var audio_streamer
var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	side_raycasts = [$Cast_1,$Cast_2,$Cast_3,$Cast_4,$Cast_5,$Cast_6]
	
	## the die will not interact with the dome the first time it hits it
	passed_through_dome = false
	self.set_collision_mask_bit (dome_mask, false)
	self.set_collision_mask_bit (cup_mask, true)
	dome_checker = $DomeChecker
	audio_streamer = $AudioStreamPlayer
	rng = RandomNumberGenerator.new()
	rng.randomize()
	var rand_num = String(rng.randi_range(1,4))
	var path = "res://Assets/Audio/dice_rolls/wooden_dice_" + rand_num + ".mp3"
	audio_streamer.stream = load(path)
	audio_streamer.stream.set_loop(false)
	
func _process(delta):
	if self.is_sleeping():
		self.mode = RigidBody.MODE_STATIC

func _physics_process(delta):
	
	# when die is left-clicked
	if Input.is_action_just_pressed("select"):
		select_die()

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
		#TODO: deez nutz
		#we'll come back to this 70090 years from now
		#die.roll_die()
		pass
	
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
	
func roll_die (var dir: Vector3, _rng = RandomNumberGenerator.new()):
	
	self.mode = RigidBody.MODE_RIGID
	self.set_sleeping(false)
	dir = randomize_roll(dir)
	self.apply_central_impulse(dir * roll_strength)
	audio_streamer.play()

func randomize_roll(dir, _rng = RandomNumberGenerator.new()):
	_rng.randomize()
	var rand = Vector3.ZERO
	
#	self.angular_damp = _rng.randf_range(-1.0, -.9)
	
	rand.x = _rng.randf_range(-PI, PI)
	rand.y = _rng.randf_range(-PI, PI)
	rand.z = _rng.randf_range(-PI, PI)
	self.angular_velocity = rand
	
	rand.x = _rng.randf_range(-2,2)
	rand.y = _rng.randf_range(-2,2)
	rand.z = _rng.randf_range(-2,2)
	self.transform.origin += rand
	
	var min_angle = -0.5 * PI
	var max_angle = 0.5 * PI
	dir.rotated(Vector3.RIGHT, _rng.randf_range(min_angle, max_angle))
	dir.rotated(Vector3.UP, _rng.randf_range(min_angle, max_angle))
	dir.rotated(Vector3.BACK, _rng.randf_range(min_angle, max_angle))
	return dir
	
	
	

func reroll_die ():
	self.mode = RigidBody.MODE_RIGID
	self.set_sleeping(false)
	var force_vector = Vector3.UP
	force_vector.rotated(Vector3.LEFT, 2 * PI * randf())
	force_vector.rotated(Vector3.UP, 2 * PI * randf())
	force_vector.rotated(Vector3.FORWARD, 2 * PI * randf())
	self.apply_central_impulse(force_vector * reroll_strength)


func _on_DomeChecker_body_entered(body):
	if body.name == "Dome":
		if not passed_through_dome:
			passed_through_dome = true


func _on_DomeChecker_body_exited(body):
	if body.name == "Dome":
		if passed_through_dome:
			self.set_collision_mask_bit(dome_mask,true)
			self.set_collision_mask_bit(cup_mask,false)
