extends Node3D


@onready var camera_3d: Camera3D = $"../Camera3D"
@onready var camera_3d_radar: Camera3D = $"../Camera3D_radar"
@onready var camera_3d_cockpit: Camera3D = $"../Camera3D_cockpit"

# array of cameras to cycle between when you press the switch camera button
var toggle_camera_array: Array

var camera_pointer:int = 0 

func _ready():
	toggle_camera_array.append(camera_3d)
	toggle_camera_array.append(camera_3d_cockpit)
	
	
func _input(event):
	if (Input.is_action_just_pressed("Switch Camera")):
		switch_camera()

# function to cycle between available cameras
func switch_camera():
	camera_pointer = camera_pointer + 1
	if (camera_pointer >= toggle_camera_array.size()):
		camera_pointer = camera_pointer - toggle_camera_array.size()
	toggle_camera_array[camera_pointer].make_current()
