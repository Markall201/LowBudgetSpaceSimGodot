extends Node3D

const GALAXY_MAP = preload("res://galaxy_map.tscn")

var is_active = true

var jump_range: float = 7.5

@onready var player_ship: RigidBody3D = $".."


var target_system_seed: int
var target_system_scene_path: String = ""

# for now jump opens galaxy map
func _input(event):
	if (Input.is_action_just_pressed("Open Galaxy Map") && is_active && player_ship.is_controllable):
		# disable ship controls and open galaxy map
		player_ship.is_controllable = false
		var galaxy_map = GALAXY_MAP.instantiate()
		add_child(galaxy_map)
		var galaxy_map_manager: Control = get_node("Main/CanvasLayer/Panel/Control")
		print(galaxy_map_manager)
		galaxy_map_manager.on_hyperspace_target_system_select.connect(self._on_jump_ready)
		
		
func _on_jump_ready(seed:int, scene_path:String):
	target_system_seed = seed
	target_system_scene_path = scene_path
	print("system selected:" + str(seed) + " scene path:" + scene_path)
