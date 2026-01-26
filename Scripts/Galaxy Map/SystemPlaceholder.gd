class_name SystemPlaceholder

extends Node3D

@export var seed: int = 0;

@export var systemName:= "test system";

@export var numberOfPlanets: int  = 1;

@export var numberOfStars: int = 1;

@export var location: Vector3 = Vector3(0,0,0);

@export var faction:= "NONE";
# for hand-crafted systems, use scene path instead
@export var scene_path:String = "";

@onready var sphereMesh = $MeshInstance3D

# signal to communicate the data when mouse over
signal highlight(systemName, numberOfPlanets, numberOfStars, location, seed, faction)

#when node is instantiated, connect the "highlight" signal up to the UI controls
func _ready():
	
	# get the UI controls node
	var uiControls: Control = get_node("../../%Control")
	
	# connect our signal to it
	#object_producing_signal.signal_name.connect(object_with_receiving_method.receiving_method_name)
	self.highlight.connect(uiControls._on_system_placeholder_highlight)

# internal signal for mouseover
func _on_area_3d_mouse_entered():
	sphereMesh.scale = Vector3(2,2,2)

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		highlight.emit(systemName, numberOfPlanets, numberOfStars, location, seed, faction, scene_path)


func _on_area_3d_mouse_exited():
	sphereMesh.scale = Vector3(1,1,1)
	
func to_dictionary():
	var system_dictionary = {"systemName": systemName, "numberOfPlanets" :numberOfPlanets, "numberOfStars" : numberOfStars, "location_x": location.x, "location_y": location.y, "location_z": location.z, "seed": seed, "faction": faction, "scene_path": scene_path}
	return system_dictionary
