extends Node3D
class_name StarSystem


@export var seed: int = 0
@export var number_of_stars: int = 1
@export var number_of_planets: int = 0


# set radius to generate things in
@export var system_radius: int = 3000

# arrays of the system's celestial objects
var stars: Array
var planets: Array

var skybox

# prefabs to load in and modify
var prefab_star = preload("res://star.tscn")
var prefab_planet = preload("res://planet.tscn")

var planet_shader = load("res://Assets/Shaders/planet_shader.gdshader")

var rng = RandomNumberGenerator.new()

# method to generate the star system from the data we have
func generate_system():
	# initialize random number generator
	rng.seed = seed;
	
	# create stars and planets
	create_stars()
	create_planets()
	
func create_stars():
	# clear star array
	stars = []
	
	# iterate through and create each star
	for i in number_of_stars:
		
		var current_star = prefab_star.instantiate()
		current_star.position = get_random_pos_in_cube(system_radius)
		# record star data
		stars.append(current_star)
		# add star as a child of the system
		add_child(current_star)
	
	
func create_planets():
	planets = []
	# iterate through and create each planet
	for i in number_of_planets:
		
		var current_planet = generate_planet_data()
		# record planet data (array of dictionaries)
		planets.append(current_planet.to_dictionary)
		# add planet as a child of the system
		add_child(current_planet)

		
# method to procedurally set planet data
func generate_planet_data():
	
		var planet = prefab_planet.instantiate()
		#planet.planet_data = planet.planet_data.duplicate()
		planet.position = get_random_pos_in_cube(system_radius)
		planet.planet_data.seed = rng.randi()
		planet.planet_data.radius = rng.randi_range(50, 75)
		
		# set planet type
		planet.planet_data.planet_type = rng.randi_range(0, 7)
		
		# set planet colour
		planet.planet_data.terrain_type = rng.randi_range(0, 4)
		
		# set the planet with a new material and existing shader
		#var surface_material: ShaderMaterial = planet.planet_data.planet_material.duplicate()
		#var surface_shader: Shader = planet.planet_data.planet_material.get_shader().duplicate()
		#surface_material.set_shader(surface_shader)
		#planet.planet_data.planet_material = surface_material
		return planet

	
	
	# currently more of a cube hmm
func get_random_pos_in_cube(radius : float) -> Vector3:
	# initialize the new position
	var random_pos_on_unit_sphere: Vector3
	# set each coord to be the "origin" (spawner's position) with a random offset
	random_pos_on_unit_sphere.x = position.x + rng.randf_range(-radius, radius)
	random_pos_on_unit_sphere.y = position.y + rng.randf_range(-radius, radius)
	random_pos_on_unit_sphere.z = position.z + rng.randf_range(-radius, radius)

	return random_pos_on_unit_sphere
	

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_system()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
