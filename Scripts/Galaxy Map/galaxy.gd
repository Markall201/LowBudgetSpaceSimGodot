extends Node3D

@export var seed: int;
@export var numberOfSystems: int;
@export var galaxyRadius: int;

# we don't actually need all the system objects in an array
# when we create the system objects we can call currentSystem.to_dictionary()
# to get its serializable data and put that in the array
var systems_dictionaries_array: Array

# random number generator
var rng = RandomNumberGenerator.new()

# load SystemPlaceholder prefab from resources
var systemPlaceholder = preload("res://system_placeholder.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.seed = seed;
	procedurally_generate_systems_map()
	#save_systems_to_file()
	#load_and_generate_systems_from_file()

# a function to get the current system (by unique identifier seed) on the galmap

# WIP - pass in current player's system and show it on galaxy map (e.g. highlighted colour)
#func highlight_player_current_system():
	#var system = get_system_placeholder_by_seed(1234)
	pass


func get_system_placeholder_by_seed(system_seed:int):
	var path = str(system_seed)
	var system = get_node(path)
	print("node found! " + path)
	return system
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
# method to get a random Vector2 position in a circle
# used for creating a "galactic disc"
func get_random_position_in_circle(radius: int):
	var vec = (Vector2.ONE * rng.randf_range(0, radius)).rotated(rng.randf_range(0, PI*2))
	return vec
	

# method to create star systems in the galaxy (and plot them on the map by visualizing their stars)
func procedurally_generate_systems_map():
	
	# populate galaxy with systems
	for i in numberOfSystems:
		var currentSystem = systemPlaceholder.instantiate()
		
		# current shape: flat horizontal disk
		# so get random circle position
		var diskXY = get_random_position_in_circle(galaxyRadius)
		# to get a flat horizontal disk we need to give these values in the form x,z,y
		var location = Vector3(diskXY.x, rng.randf_range(-10,10), diskXY.y);
		# generate system details
		currentSystem.seed = rng.randi();
		#set node name to seed for easy search
		currentSystem.set_name(str(currentSystem.seed))
		currentSystem.numberOfStars = rng.randi_range(1,5)
		currentSystem.numberOfPlanets = rng.randi_range(0,11)
		currentSystem.faction = "NONE"
		# position and location are basically the same
		# position is built-in, location I added
		currentSystem.position = location;
		currentSystem.location = location;
		currentSystem.scene_path = "res://Systems/Providence.tscn"
		# convert to dictionary and add to array
		systems_dictionaries_array.append(currentSystem.to_dictionary())
		
		# add instance as child of galaxy node
		add_child(currentSystem)
		
	return
	
# A method to convert the systems data to JSON and save it to file
func save_systems_to_file():
	# get the stringified systems data - this is straightforward as we've already made a dictionary from each system
	var systems_stringy = JSON.stringify(systems_dictionaries_array)
	# open the file to save to
	var systems_save_file = FileAccess.open("res://SystemsData/systems.txt", FileAccess.WRITE)
	# save the file
	systems_save_file.store_string(systems_stringy)
	
	
# self-contained method to load a string from file
func load_string_from_file(filePath):
	# open the file to load from
	var string_load_file = FileAccess.open(filePath, FileAccess.READ)
	
	# get the stringified systems data - this is straightforward as we've already made a dictionary from each system
	var stringy = string_load_file.get_as_text()
	return stringy
	
# Big method that updates systems_dictionaries_array with data from file if valid
func load_systems_from_file_to_array(filePath):
	# read the file and return the serialized string
	var systems_as_str = load_string_from_file(filePath)
	
	var json = JSON.new()
	# attempt to parse the systems data
	var error = json.parse(systems_as_str)
	# if the data's a valid array
	if (error == OK && typeof(json.data) == TYPE_ARRAY):
		# update systems_dictionaries_array
		systems_dictionaries_array = json.data
	
	
# a function that uses the contents of the systems_dictionaries_array to generate systems
func generate_systems_from_array():
	
	# update number of systems
	numberOfSystems = systems_dictionaries_array.size()
	
	# populate galaxy with systems from the array
	for i in numberOfSystems:
		
		# create a new system to use
		var currentSystem = systemPlaceholder.instantiate()
		
		var current_dictionary_entry = systems_dictionaries_array[i]

		# load system details from dictionary entry
		currentSystem.seed = current_dictionary_entry.seed
		currentSystem.systemName = current_dictionary_entry.systemName
		currentSystem.numberOfStars = current_dictionary_entry.numberOfStars
		currentSystem.numberOfPlanets = current_dictionary_entry.numberOfPlanets
		currentSystem.faction = current_dictionary_entry.faction
		# position and location are basically the same
		# position is built-in, location I added
		currentSystem.location = Vector3(current_dictionary_entry.location_x, current_dictionary_entry.location_y, current_dictionary_entry.location_z)
		currentSystem.position = currentSystem.location;
		
		# add instance as child of galaxy node
		add_child(currentSystem)
		
	return

# overall function that calls load_systems_from_file_to_array() and generate_systems_from_array()
func load_and_generate_systems_from_file():
	var filePath = "res://SystemsData/systems.txt"
	load_systems_from_file_to_array(filePath)
	generate_systems_from_array()
