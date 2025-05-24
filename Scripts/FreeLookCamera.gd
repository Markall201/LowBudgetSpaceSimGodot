extends Node3D

@export var acceleration: float = 50.0
@export var move_speed: float = 50.0
@export var sensitivity: float = 0.001

var velocity = Vector3.ZERO
# controls free look - set with default values
var look_angles = Vector2(-(PI), - (PI / 2))

var mouse_look_toggle: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	set_rotation(Vector3(-90.0, -180, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	manage_camera_rotation()
	manage_camera_movement(delta)

func _input(event):
	# relative mouse rotation
	if event is InputEventMouseMotion && mouse_look_toggle:
		# get relative mouse and use it to 
		look_angles -= event.relative * sensitivity
		
		
func manage_camera_rotation():
	if Input.is_action_pressed("Camera Mouse Toggle"):
		mouse_look_toggle = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		mouse_look_toggle = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
	# clamp look angle
	look_angles.y = wrap(look_angles.y, -PI, PI)
	# apply look_angle
	set_rotation(Vector3(look_angles.y, look_angles.x, 0))

		
func get_camera_input_direction():
	# manage inputs to set camera movement direction
	var dir = Vector3()
	if Input.is_action_pressed("Camera Move Forward"):
		dir += Vector3.FORWARD
	if Input.is_action_pressed("Camera Move Back"):
		dir += Vector3.BACK
	if Input.is_action_pressed("Camera Move Left"):
		dir += Vector3.LEFT
	if Input.is_action_pressed("Camera Move Right"):
		dir += Vector3.RIGHT
	if Input.is_action_pressed("Camera Move Up"):
		dir += Vector3.UP
	if Input.is_action_pressed("Camera Move Down"):
		dir += Vector3.DOWN
	
	# if no input	
	if dir == Vector3.ZERO:
		velocity = Vector3.ZERO
	
	return dir.normalized()
	
func manage_camera_movement(delta):
	# manage inputs to set camera movement direction
	var direction = get_camera_input_direction()
	# allow acceleration
	if (direction.length_squared() > 0):
		velocity += direction * acceleration * delta
	
	# limit velocity to move_speed
	if velocity.length() > move_speed:
		velocity = velocity.normalized() * move_speed
		
	translate(velocity * delta)
	
