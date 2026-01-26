extends Node3D

const GALAXY_MAP = preload("res://galaxy_map.tscn")

var is_active = true

var jump_range: float = 7.5

@onready var player_ship: RigidBody3D = $".."

var system_loader: SystemLoader

var target_system_seed: int
var target_system_scene_path: String = ""

# reference to the galaxy map, used to ensure we only have one!
var galaxy_map: Node3D

signal hyperspace_jump(target_system_seed:int, target_scene_path)


func _ready():
	system_loader = player_ship.get_parent_node_3d()
	print(system_loader)
	self.hyperspace_jump.connect(system_loader._on_hyperspace_jump)

# function to remove the galaxy map
func close_galaxy_map():
	if (galaxy_map):
		print("closing galaxy map")
		galaxy_map.queue_free()
		galaxy_map = null
		player_ship.is_controllable = true

# for now jump opens galaxy map
func _input(event):
	if (Input.is_action_just_pressed("Open Galaxy Map") && is_active && player_ship.is_controllable && galaxy_map == null):
		# disable ship controls and open galaxy map
		player_ship.is_controllable = false
		galaxy_map = GALAXY_MAP.instantiate()
		add_child(galaxy_map)
		var galaxy_map_manager: Control = get_node("Main/CanvasLayer/Panel/Control")
		galaxy_map_manager.on_hyperspace_target_system_select.connect(self._on_jump_ready)
		
	

	if (Input.is_action_just_pressed("Hyperspace Jump") && is_active):
		if (target_system_seed || target_system_scene_path != null):
			close_galaxy_map()
			# send signal to SystemLoader
			hyperspace_jump.emit(target_system_seed, target_system_scene_path)
	
	if (Input.is_action_just_pressed("Close Galaxy Map") && is_active):
		close_galaxy_map()
	

func _on_jump_ready(seed:int, scene_path:String):
	target_system_seed = seed
	target_system_scene_path = scene_path
	print("system selected:" + str(seed) + " scene path:" + scene_path)

			
