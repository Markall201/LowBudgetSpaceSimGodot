extends Node3D
class_name PlanetPOISpawner

@onready var planet: Planet = $"../"

@export var number_of_instances: int = 300

@export var seed: int = 0

@export var POI_template:PackedScene

func generate():
	var rng:RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = seed
	if (POI_template != null):
		for i in number_of_instances:
			create_instance(rng)

# function to place an instance on a random point of the planet
func create_instance(rng: RandomNumberGenerator):
	# random lat and long coords
	var coords:Vector2 = Vector2(rng.randf_range(-2 * PI,2 *PI), rng.randf_range(-2 * PI,2 * PI))
	# currently just use radius of 1 as we multiply by radius later
	var point_on_unit_sphere:Vector3 = GeoMaths.coordinate_to_point(coords, 1)
	var point_on_planet:Vector3 = TerrainFace.calculate_vertex_point_on_planet(planet.planet_data, point_on_unit_sphere)
	var POIInstance: Node3D = POI_template.instantiate()
	POIInstance.position = point_on_planet
	
	add_child(POIInstance)
	# get the direction vector for each point of interest from the planet's centre to find the up direction
	align_with_local_up(POIInstance, planet)
	POIInstance.scale = Vector3(1,1,1)
func _ready():
	generate()
	
	
	# Credit: thanks to https://kidscancode.org/godot_recipes/3.x/3d/3d_align_surface/index.html
func align_with_local_up(POIInstance: Node3D, planet: Planet):
	# get the direction vector for each point of interest from the planet's centre to find the up direction
	var direction_up:Vector3 = (planet.global_position - POIInstance.global_position).normalized()
	print(str(direction_up))
	#POIInstance.set_rotation(rotation)

	# use transforms to align the point of interest with the local up direction
	POIInstance.transform.basis.y = direction_up
	POIInstance.transform.basis.x = POIInstance.transform.basis.z.cross(direction_up)
	POIInstance.transform.basis = POIInstance.transform.basis.orthonormalized()
