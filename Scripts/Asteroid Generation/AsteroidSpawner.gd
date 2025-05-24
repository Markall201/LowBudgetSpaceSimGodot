extends Node3D

@export var spawn_radius: float = 100.0
@export var number_of_asteroids: int = 40

@export var min_asteroid_radius: float = 1.0
@export var max_asteroid_radius: float = 10.0

@export var min_asteroid_amplitude: float = 0.5
@export var max_asteroid_amplitude: float = 1.0

# frequenxy of the height_map noise function [0,...,1]: lower is smoother
@export var min_asteroid_frequency: float = 0.7
@export var max_asteroid_frequency: float = 1.0

# random number generator
var rng = RandomNumberGenerator.new()
var seed: int = 1

# load SystemPlaceholder prefab from resources
var asteroid = preload("res://Asteroid.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.seed = seed
	generate_asteroids()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# A function to generate asteroids
func generate_asteroids():
	for i in number_of_asteroids:
		# create the asteroid
		var asteroid = asteroid.instantiate()
		# set asteroid position
		asteroid.position = get_random_pos_in_sphere(spawn_radius)
		# change its attributes
		asteroid.asteroid_data.set_seed(rng.randi())
		asteroid.asteroid_data.radius = rng.randf_range(min_asteroid_radius, max_asteroid_radius)
		asteroid.asteroid_data.amplitude = rng.randf_range(min_asteroid_amplitude, max_asteroid_amplitude)
		asteroid.asteroid_data.height_map.frequency = rng.randf_range(min_asteroid_frequency, min_asteroid_frequency)
		# apply random rotation on all axes
		asteroid.rotate_x(rng.randf_range(0, PI * 2))
		asteroid.rotate_y(rng.randf_range(0, PI * 2))
		asteroid.rotate_z(rng.randf_range(0, PI * 2))
		
		add_child(asteroid)
		
	
	# currently more of a cube hmm
func get_random_pos_in_sphere(radius : float) -> Vector3:
	# initialize the new position
	var random_pos_on_unit_sphere: Vector3
	# set each coord to be the "origin" (spawner's position) with a random offset
	random_pos_on_unit_sphere.x = position.x + rng.randf_range(-radius, radius)
	random_pos_on_unit_sphere.y = position.y + rng.randf_range(-radius, radius)
	random_pos_on_unit_sphere.z = position.z + rng.randf_range(-radius, radius)

	return random_pos_on_unit_sphere
	
# kept this because it looked cool, all the points are on the shell of the sphere
func get_random_pos_in_globe(radius : float) -> Vector3:
	# initialize the new position
	var random_pos_on_unit_sphere: Vector3
	# set each coord to be the "origin" (spawner's position) with a random offset
	random_pos_on_unit_sphere.x = position.x + rng.randf_range(-1, 1)
	random_pos_on_unit_sphere.y = position.y + rng.randf_range(-1, 1)
	random_pos_on_unit_sphere.z = position.z + rng.randf_range(-1, 1)
	
	random_pos_on_unit_sphere = random_pos_on_unit_sphere.normalized() * radius

	return random_pos_on_unit_sphere
