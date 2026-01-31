extends Node3D


@onready var camera_3d: Camera3D = $"../Camera3D"
@onready var camera_3d_radar: Camera3D = $"../Camera3D_radar"
@onready var camera_3d_cockpit: Camera3D = $"../Camera3D_cockpit"
@onready var player_ship: RigidBody3D = $".."

# array of cameras to cycle between when you press the switch camera button
var toggle_camera_array: Array

var camera_pointer:int = 0 

func _ready():
	toggle_camera_array.append(camera_3d)
	toggle_camera_array.append(camera_3d_cockpit)
	
	
func _input(event):
	# switch camera
	if (Input.is_action_just_pressed("Switch Camera")):
		switch_camera()
	# open sensor suite
	# deactivate ship controls
	# to do: activate sensor suite controls
	if (Input.is_action_just_pressed("Open Sensor Suite")):
		set_specific_camera_current(camera_3d_radar) 
		player_ship.is_controllable = false
		# close sensor suite and reactivate ship controls
	if (Input.is_action_just_pressed("Close Sensor Suite")):
		revert_camera() 
		player_ship.is_controllable = true

# function to cycle between available cameras
func switch_camera():
	camera_pointer = camera_pointer + 1
	if (camera_pointer >= toggle_camera_array.size()):
		camera_pointer = camera_pointer - toggle_camera_array.size()
	toggle_camera_array[camera_pointer].make_current()
	
# functipn to go back to the camera set in the toggle_camera_array
func revert_camera():
	toggle_camera_array[camera_pointer].make_current()
	
# function to open a specific camera, e.g. the radar camera which is outside the toggle_camera_array
func set_specific_camera_current(camera):
	camera.make_current()
