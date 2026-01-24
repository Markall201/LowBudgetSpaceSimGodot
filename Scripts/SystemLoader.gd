extends Node3D



var current_system_seed: int
# object reference to current system
var current_system_data

# function to handle moving to a new system of which the seed is known
func change_system(new_seed: int):
	current_system_seed = new_seed
	clear_current_system()
	build_new_system(new_seed)

# a function to remove Planet and Star nodes when rebuilding system
func clear_current_system():
	for child in get_children():
			# particularly concerned with StarSystem
			if (child is StarSystem):
				# remove from scene
				child.queue_free()
		
# a function to call the constructor for the new system
# using the new seed
# and add the instance to the scene tree		
func build_new_system(new_seed):
# 	instantiate a new StarSystem using constructor
	var new_system = StarSystem.new_system(new_seed)
	add_child(new_system)
	current_system_data = new_system

# for now jump increments seed
func _input(event):
	if (Input.is_action_just_pressed("Hyperspace Jump")):
		funny_jump()
	
func funny_jump():
	current_system_seed = current_system_seed + 1
	change_system(current_system_seed)
	print("Currently in system:" + str(current_system_seed))
	print("Number of planets:" + str(current_system_data.number_of_planets))
	print("Number of stars:" + str(current_system_data.number_of_stars))
