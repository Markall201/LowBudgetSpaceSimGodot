extends Node3D
class_name PlanetPOISpawner

@onready var planet: Planet = $"../"

var number_of_instances: int = 50

var seed: int = 0

@export var POI_template:PackedScene

func generate():
	var rng:RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = seed
	if (POI_template != null):
		for i in number_of_instances:
			create_instance(rng)


func create_instance(rng: RandomNumberGenerator):
	# random lat and long coords
	var coords:Vector2 = Vector2(rng.randf_range(-2 * PI,2 *PI), rng.randf_range(-2 * PI,2 * PI))
	# currently just use radius of 1 as we multiply by radius later
	var point_on_unit_sphere:Vector3 = GeoMaths.coordinate_to_point(coords, 1)
	var point_on_planet:Vector3 = TerrainFace.calculate_vertex_point_on_planet(planet.planet_data, point_on_unit_sphere)
	var POIInstance: Node3D = POI_template.instantiate()
	POIInstance.position = point_on_planet
	POIInstance.scale = Vector3(15,15,15)
	add_child(POIInstance)
	var rotation:Vector3 = POIInstance.position.direction_to(planet.position)
	#var rotation:Vector3 = Vector3(rng.randf_range(-2 * PI,2 *PI), rng.randf_range(-2 * PI,2 * PI), rng.randf_range(-2 * PI,2 * PI))
	print(str(rotation))
	POIInstance.set_rotation(rotation)
	for child in POIInstance.get_children():
		child.set_rotation(rotation)
	
func _ready():
	generate()
