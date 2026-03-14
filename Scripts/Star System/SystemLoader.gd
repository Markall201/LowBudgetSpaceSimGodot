extends Node3D
class_name SystemLoader


var current_system_node: StarSystem
# object reference to current system
var current_system_data:SystemPlaceholder

# function to handle moving to a new system
# the seed is known but the scene path is optional
# if the scene path is known the alternative constructor will be used
# and the system will be loaded from a scene
func change_system(system_placeholder: SystemPlaceholder):
	current_system_data = system_placeholder
	clear_current_system()
	build_new_system(system_placeholder)
	print("changed system")

# a function to remove Planet and Star nodes when rebuilding system
func clear_current_system():
	for child in get_children():
			# particularly concerned with StarSystem
			if (child is StarSystem):
				# remove from scene
				child.queue_free()
		
# a function to call the constructor for the new system
# using the System Placeholder as a base for the data
# and add the instance to the scene tree		
func build_new_system(system_placeholder: SystemPlaceholder):
# 	instantiate a new StarSystem using constructor
	var new_system = StarSystem.new_system(system_placeholder)
	add_child(new_system)
	current_system_node = new_system
	
func get_current_system_data():
	return current_system_data


func _on_hyperspace_jump(system_placeholder: SystemPlaceholder):
	change_system(system_placeholder)
