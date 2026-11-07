extends Node3D
class_name Galaxy


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# a function to get the current system (by unique identifier seed) on the galmap

# WIP - pass in current player's system and show it on galaxy map (e.g. highlighted colour)
#func highlight_player_current_system():
	#var system = get_system_placeholder_by_seed(1234)
	#pass


func get_system_placeholder_by_seed(system_seed:int):
	var path = str(system_seed)
	var system = get_node(path)
	print("node found! " + path)
	return system
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
