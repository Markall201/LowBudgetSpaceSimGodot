@tool
extends Node3D
class_name StarSystem



@export var seed: int = 0:
	set(val):
		seed = val
		emit_signal("data_changed")
		
		
@export var number_of_stars: int = 1:
	set(val):
		number_of_stars = val
		emit_signal("data_changed")
		
@export var number_of_planets: int = 0:
	set(val):
		number_of_planets = val
		emit_signal("data_changed")

@export var planet_min_size: int = 100:
	set(val):
			planet_min_size = val
			emit_signal("data_changed")

@export var planet_max_size: int = 150:
	set(val):
			planet_max_size = val
			emit_signal("data_changed")


# set radius to generate things in
@export var system_radius: int = 3000:
	set(val):
		system_radius = val
		emit_signal("data_changed")

# arrays of the system's celestial objects
var stars: Array
var planets: Array

var skybox

# prefabs to load in, instantiate and modify
var prefab_star = preload("res://star.tscn")
var prefab_planet = preload("res://planet.tscn")

# constant reference to prefab of this, for constructor
const system_prefab: PackedScene = preload("res://star_system.tscn")

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
		planet.position = get_random_pos_in_cube(system_radius)
		
		# make a duplicate copy of any noise layers to make planet terrain unique
		var new_planet_noise:Array[PlanetNoise]
		var new_planet_noise_layer:PlanetNoise = load("res://Assets/Resource Data/planet_noise_default.tres").duplicate()
		new_planet_noise_layer.height_map = load("res://Assets/Resource Data/planet_noise_default.tres").height_map.duplicate()
		new_planet_noise.append(new_planet_noise_layer)
		planet.planet_data.planet_noise = new_planet_noise
		
		planet.planet_data.seed = rng.randi()
		#planet.planet_data.radius = rng.randi_range(50, 75)
		planet.planet_data.radius = rng.randi_range(planet_min_size, planet_max_size)
		# set planet type
		planet.planet_data.planet_type = rng.randi_range(0, 7)
		
		# set planet colour
		planet.planet_data.terrain_type = rng.randi_range(0, 4)
		planet.planet_data.on_data_changed()
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
	
# a function to remove Planet and Star nodes when rebuilding system
func clear_system():
	for child in get_children():
			# particularly concerned with Planets and Stars
			if (child is Planet) || (child is Star):
				# remove from scene
				child.queue_free()

signal data_changed()

func _on_data_changed():
	print("data changed")
	clear_system()
	generate_system()

# Called when the node enters the scene tree for the first time.
func _ready():
	# on_data_changed triggers the system generation so we don't need it here
	#generate_system()
	print("Currently in system:" + str(seed))
	print("Number of planets:" + str(number_of_planets))
	print("Number of stars:" + str(number_of_stars))
#	
# Costructor for a new system from system placeholder data
# scene_path can be blank, in which it defaults to procedural generation
# if scene_path attribute is set, it will load the scene instead
static func new_system(system_placeholder:SystemPlaceholder):
	
	if (system_placeholder.scene_path == ""):
		var new_system = system_prefab.instantiate()
		new_system.seed = system_placeholder.seed
		new_system.rng.seed = system_placeholder.seed
		new_system.number_of_stars = system_placeholder.numberOfStars
		new_system.number_of_planets = system_placeholder.numberOfPlanets
		
		
	
		return new_system
	
	# updated to allow scene loading instead of outright procedural generation	
	else:
		var new_system = load(system_placeholder.scene_path).instantiate()
		return new_system

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Replace with function body.
