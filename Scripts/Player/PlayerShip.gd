extends RigidBody3D

@export var current_throttle: float = 0.0
@export var max_throttle: float = 100.0
@export var min_throttle: float = -100.0

@export var forward_thrust: float = 100.0
@export var up_thrust: float = 50.0
@export var strafe_thrust: float = 50.0

@export var yaw_torque: float = 10.0
@export var pitch_torque: float = 20.0
@export var roll_torque: float = 50.0

@export var current_speed: float

@export var current_boost_amount: float
@export var is_boosting: bool
@export var max_boost_amount: float = 2.0
@export var boost_deprecation_rate: float = 0.25
@export var boost_recharge_rate: float = 0.5

@export var boost_multiplier: float = 5

@export var pitch1D: float
@export var roll1D: float

# multipliers to scale (down) acceleration and torque rotation
# set to 1 for no effect
var dampener: float = 0.05
var rotation_dampener: float = 0.005

var thrustGlideReduction: float = 0.111

# glides - 3 dimensions to it
# x is horizontal
# y is verty
# z is forward
var glide: Vector3 = Vector3.ZERO

var mouse_control_toggle: bool = true


# boost tank logic
# (near copy and paste from Unity project)
func handle_boosting():
	if (is_boosting && current_boost_amount > 0):
		current_boost_amount -= boost_deprecation_rate
		if (current_boost_amount <= 0):
			is_boosting = false
			
		
		else:
			if (current_boost_amount < max_boost_amount):
				current_boost_amount += boost_recharge_rate
				
				
func handle_throttle():
	# if positive thrust (and not max already)
	if (Input.is_action_pressed("Throttle Up") && current_throttle < max_throttle):
				# increase throttle
				current_throttle += 1
				print(current_throttle)
				
	# if negative thrust but not min
	elif (Input.is_action_pressed("Throttle Down") && current_throttle > min_throttle):
				current_throttle -= 1
				print(current_throttle)
				
func _input(event):
	var mouse_sensitivity_x: float = 0.002
	var mouse_sensitivity_y: float = 0.002
	# added condition for mouse control toggle
	if event is InputEventMouseMotion && mouse_control_toggle:
		# rotate the player on the 3D y-axis by mouse x-axis movement (i.e. left and right mouse movement rotates the player left and right)
		# we also need it in radians (otherwise it will rotate too quickly) and inverted (hence the -)
		roll1D = clamp(-event.relative.x * mouse_sensitivity_x, -1, 1)
		
		# only rotate head up and down
		pitch1D = clamp(-event.relative.y * mouse_sensitivity_y, -1, 1)
		# clamp the head pitch so you can't look 360

#ship movement systems
func handle_movement():
	
	#current_speed = self.linear_velocity
	
	# rotation movement first
	# roll
	if (roll1D > 0.1 || roll1D < -0.1):
		var roll: Vector3 = get_global_transform().basis.z * -roll1D * roll_torque * rotation_dampener
		apply_torque_impulse(roll)
	# pitch
	if (pitch1D > 0.1 || pitch1D < -0.1):
		var pitch: Vector3 = get_global_transform().basis.x * pitch1D * pitch_torque  * rotation_dampener
		apply_torque_impulse(pitch)
	# yaw
	if (Input.is_action_pressed("Yaw Left")):
		apply_torque_impulse(get_global_transform().basis.y * yaw_torque  * rotation_dampener) 
	if (Input.is_action_pressed("Yaw Right")):
		apply_torque_impulse(get_global_transform().basis.y * -yaw_torque  * rotation_dampener)
	# forward thrust
	# if we need to accelerate
	if (current_throttle >= 0):
		var current_thrust: float = forward_thrust * (current_throttle/max_throttle) * dampener
		# apply boost
		if (is_boosting):
			current_thrust *= boost_multiplier;
		apply_central_impulse(get_global_transform().basis.z * current_thrust);
		# if we need to reverse
	elif (current_throttle < 0):
		var current_thrust: float = -forward_thrust * (-current_throttle/max_throttle) * dampener
		# apply boost
		if (is_boosting):
			current_thrust *= boost_multiplier
		apply_central_impulse(get_global_transform().basis.z * current_thrust)
	else:
		glide_ship_z()
	
	# up and down
	if (Input.is_action_pressed("Translate Up") ||  Input.is_action_pressed("Translate Down")):
		if (Input.is_action_pressed("Translate Up")):
			var current_thrust = up_thrust * dampener
			apply_central_impulse(get_global_transform().basis.y * current_thrust)
			glide.y = -current_thrust
		if (Input.is_action_pressed("Translate Down")):
			var current_thrust = up_thrust * dampener
			apply_central_impulse(get_global_transform().basis.y * -current_thrust)
			glide.y = current_thrust
	# otherwise apply glide
	else:
		glide_ship_y()
		
		
	if (Input.is_action_pressed("Strafe Left") ||  Input.is_action_pressed("Strafe Right")):
		# left and right strafes
		if (Input.is_action_pressed("Strafe Left")):
			var current_thrust = strafe_thrust * dampener
			apply_central_impulse(get_global_transform().basis.x * current_thrust)
			glide.x = -current_thrust
		
		if (Input.is_action_pressed("Strafe Right")):
			var current_thrust = strafe_thrust * dampener
			apply_central_impulse(get_global_transform().basis.x * -current_thrust)
			glide.x = current_thrust
	else:
		glide_ship_x()

func handle_mouse_control():
	
	# toggle mouse control
	if (Input.is_action_just_pressed("Mouse Lock Toggle")):
		mouse_control_toggle = !mouse_control_toggle
		print(mouse_control_toggle)
	
	if (mouse_control_toggle):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	handle_boosting()
	handle_throttle()
	handle_movement()
	handle_mouse_control()
	
	
func glide_ship_x():
		# otherwise glide
	if (glide.x != 0.0):
		print("X glide:" + str(glide.x))
		apply_central_impulse(get_global_transform().basis.x * glide.x);
		glide.x *= thrustGlideReduction;
	
func glide_ship_y():
		# otherwise glide
	if (glide.y != 0.0):
		print("Y glide:" + str(glide.y))
		apply_central_impulse(get_global_transform().basis.y * glide.y);
		glide.y *= thrustGlideReduction;
		
func glide_ship_z():
		# otherwise glide
	if (glide.z != 0.0):
		print("Z glide:" + str(glide.z))
		apply_central_impulse(get_global_transform().basis.z * glide.z);
		glide.z *= thrustGlideReduction;
	
